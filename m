Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2H1Q4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:56:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53308 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2H1Q4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:56:21 -0400
From: Hitoshi Mitake <h.mitake@gmail.com>
To: sheepdog@lists.wpkg.org
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        MORITA Kazutaka <morita.kazutaka@lab.ntt.co.jp>,
        Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: [PATCH v1, RFC] sheep: writeback cache semantics in backend store
Date: Wed, 29 Aug 2012 01:56:10 +0900
Message-Id: <1346172970-31397-1-git-send-email-h.mitake@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: differences from v0 are,
* check syncfs() in configure script
* send SD_OP_FLUSH_PEER to all sheeps

This patch implements writeback cache semantics in backend store of
sheep. Current backend store farm and plain calls open() with
O_DSYNC, so every object write causes slow disk access. This incurs
overhead and this overhead is not necessary. Because current qemu
block driver invokes SD_OP_FLUSH_VDI explicitly for object
cache. Flushing disk cache with the invocation of SD_OP_FLUSH_VDI
instead of every object write is enough for current sheep.

For improving performance by reducing needless disk access, this patch
adds new inter-sheep operation SD_OP_FLUSH_PEER. Typical situation is
like this:
 qemu sends SD_OP_FLUSH_VDI -> gateway sheep sends SD_OP_FLUSH_PEER ->
 all other sheeps

And sheeps which received SD_OP_FLUSH_PEER flush disk cache with
syncfs() system call. If syncfs() is not available, sync() will be
used instead of it. Checking whether syncfs() is available or not is
done in build process.

This patch adds new command line option -W to sheep. With -W, sheep
uses writeback cache semantics in backend store.

Below is the evaluation result:
* simple dd benchmark, 1 gateway sheep and 10 sheeps for store, on xfs

without -W (writethrough)
 bs=1M count=100 oflag=direct,sync: 23.7 MB/s
 bs=1M count=100 oflag=direct: 29.8 MB/s
 bs=4K count=25600 oflag=direct,sync: 321 kB/s
 bs=4K count=25600 oflag=direct: 320 kB/s

with -W (writeback)
 bs=1M count=100 oflag=direct,sync: 36.8 MB/s
 bs=1M count=100 oflag=direct: 38.8 MB/s
 bs=4K count=25600 oflag=direct,sync: 458 kB/s
 bs=4K count=25600 oflag=direct: 5.8 MB/s

* benchmark for disk access from several VMs at once

I wrote a slack benchmark program for measuring performance of
environments which contain several VMs. Behaviour of the program is
like dd: iterate write() zero cleared buffer of specified size on a
single file which is open()ed with O_DIRECT and O_SYNC. This iteration
is repeated during specified time.

Below is the result. n VMs n sheeps are distributed on n physical
hosts equally.

4k buffer size
1 VM and 1 physical host: 4.389 MB/s
4 VM and 4 physical host: 2.378 MB/s
8 VM and 8 physical host: 2.434 MB/s

1M buffer size
1 VM and 1 physical host: 39.12 MB/s
4 VM and 4 physical host: 22.575 MB/s
8 VM and 8 physical host: 18.6 MB/s

The performance degradation can be observed. But the benchmark
produced extreme artificial workload. So I think this patch might be
suitable for certain environments with less active VMs.

Cc: MORITA Kazutaka <morita.kazutaka@lab.ntt.co.jp>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 configure.ac             |    2 +-
 include/internal_proto.h |    1 +
 sheep/ops.c              |  151 +++++++++++++++++++++++++++++++++++++++++++++-
 sheep/plain_store.c      |    5 +-
 sheep/sheep.c            |    7 ++-
 sheep/sheep_priv.h       |   10 +++
 6 files changed, 170 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 91126e2..ede61ad 100644
--- a/configure.ac
+++ b/configure.ac
@@ -124,7 +124,7 @@ AC_FUNC_VPRINTF
 AC_CHECK_FUNCS([alarm alphasort atexit bzero dup2 endgrent endpwent fcntl \
 		getcwd getpeerucred getpeereid gettimeofday inet_ntoa memmove \
 		memset mkdir scandir select socket strcasecmp strchr strdup \
-		strerror strrchr strspn strstr])
+		strerror strrchr strspn strstr syncfs])
 
 AC_CONFIG_FILES([Makefile
 		collie/Makefile
diff --git a/include/internal_proto.h b/include/internal_proto.h
index c1d116a..e63080a 100644
--- a/include/internal_proto.h
+++ b/include/internal_proto.h
@@ -65,6 +65,7 @@
 #define SD_OP_INFO_RECOVER 0xAA
 #define SD_OP_GET_VDI_COPIES 0xAB
 #define SD_OP_COMPLETE_RECOVERY 0xAC
+#define SD_OP_FLUSH_PEER 0xAD
 
 /* internal flags for hdr.flags, must be above 0x80 */
 #define SD_FLAG_CMD_RECOVERY 0x0080
diff --git a/sheep/ops.c b/sheep/ops.c
index ccb1c5e..ca4c5f9 100644
--- a/sheep/ops.c
+++ b/sheep/ops.c
@@ -21,6 +21,15 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <pthread.h>
+#include <sys/epoll.h>
+
+#ifndef HAVE_SYNCFS
+static int syncfs(int fd)
+{
+	sync();
+	return 0;
+}
+#endif
 
 #include "sheep_priv.h"
 #include "strbuf.h"
@@ -645,11 +654,115 @@ static int local_get_snap_file(struct request *req)
 	return ret;
 }
 
+static int flush_all_node(struct request *req)
+{
+	int i, ret, err_ret, epfd, waiting, cnt;
+	struct sd_node *s;
+	struct node_id *node_sent[SD_MAX_NODES];
+	struct sockfd *sfd, *sfd_sent[SD_MAX_NODES];
+	struct sd_req hdr;
+	struct vnode_info *vinfo = req->vinfo;
+	struct epoll_event ev;
+
+	err_ret = SD_RES_SUCCESS;
+
+	epfd = epoll_create(SD_MAX_NODES);
+	if (epfd == -1) {
+		eprintf("failed to create epoll file descriptor");
+		return SD_RES_EIO;
+	}
+
+	sd_init_req(&hdr, SD_OP_FLUSH_PEER);
+
+	bzero(&ev, sizeof(struct epoll_event));
+	ev.events = EPOLLIN;
+
+	for (waiting = 0, i = 0; i < vinfo->nr_nodes; i++) {
+		unsigned int wlen = 0;
+
+		s = &vinfo->nodes[i];
+
+		if (node_is_local(s)) {
+			_peer_flush();
+			continue;
+		}
+
+		sfd = sheep_get_sockfd(&s->nid);
+		if (!sfd) {
+			err_ret = SD_RES_NETWORK_ERROR;
+			goto put_sockfd;
+		}
+
+		node_sent[waiting] = &s->nid;
+		sfd_sent[waiting] = sfd;
+
+		ret = send_req(sfd->fd, &hdr, NULL, &wlen);
+		if (ret) {
+			eprintf("failed at send_req()");
+			sheep_del_sockfd(&s->nid, sfd);
+			err_ret = SD_RES_NETWORK_ERROR;
+			goto put_sockfd;
+		}
+
+		ev.data.fd = sfd->fd;
+		if (epoll_ctl(epfd, EPOLL_CTL_ADD, sfd->fd, &ev) == -1) {
+			eprintf("failed at epoll_ctl(), errno: %s", strerror(errno));
+			err_ret = SD_RES_EIO;
+			goto put_sockfd;
+		}
+
+		waiting++;
+	}
+
+	cnt = waiting;
+	while (cnt) {
+		struct epoll_event ev_nodes[SD_MAX_NODES];
+
+		bzero(ev_nodes, sizeof(struct epoll_event) * cnt);
+
+		ret = epoll_wait(epfd, ev_nodes, cnt, -1);
+		if (ret == -1) {
+			eprintf("failed at epoll_wait(), errno: %s", strerror(errno));
+			err_ret = SD_RES_EIO;
+			break;
+		}
+
+		cnt -= ret;
+
+		for (i = 0; i < ret; i++) {
+			struct sd_rsp rsp;
+
+			if (do_read(ev_nodes[i].data.fd, &rsp, sizeof(struct sd_rsp))) {
+				eprintf("failed to receive response from node");
+				err_ret = SD_RES_NETWORK_ERROR;
+				goto put_sockfd;
+			}
+		}
+	}
+
+put_sockfd:
+	for (i = 0; i < waiting; i++)
+		sheep_put_sockfd(node_sent[i], sfd_sent[i]);
+
+	close(epfd);
+
+	return err_ret;
+}
+
 static int local_flush_vdi(struct request *req)
 {
-	if (!sys->enable_write_cache)
-		return SD_RES_SUCCESS;
-	return object_cache_flush_vdi(req);
+	int ret = SD_RES_SUCCESS;
+
+	if (sys->enable_write_cache) {
+		ret = object_cache_flush_vdi(req);
+		if (ret != SD_RES_SUCCESS)
+			return ret;
+	}
+
+	if (sys->store_writeback)
+		return flush_all_node(req);
+
+	return ret;
 }
 
 static int local_flush_and_del(struct request *req)
@@ -904,6 +1017,31 @@ out:
 	return ret;
 }
 
+int _peer_flush(void)
+{
+	int fd;
+
+	fd = open(obj_path, O_RDONLY);
+	if (fd < 0) {
+		eprintf("error at open() %s, %s\n", obj_path, strerror(errno));
+		return SD_RES_NO_OBJ;
+	}
+
+	if (syncfs(fd)) {
+		eprintf("error at syncfs(), %s\n", strerror(errno));
+		return SD_RES_EIO;
+	}
+
+	close(fd);
+
+	return SD_RES_SUCCESS;
+}
+
+int peer_flush(struct request *req)
+{
+	return _peer_flush();
+}
+
 static struct sd_op_template sd_ops[] = {
 
 	/* cluster operations */
@@ -1170,6 +1308,12 @@ static struct sd_op_template sd_ops[] = {
 		.type = SD_OP_TYPE_LOCAL,
 		.process_main = local_info_recover,
 	},
+
+	[SD_OP_FLUSH_PEER] = {
+		.name = "FLUSH_PEER",
+		.type = SD_OP_TYPE_PEER,
+		.process_work = peer_flush,
+	},
 };
 
 struct sd_op_template *get_sd_op(uint8_t opcode)
@@ -1255,6 +1399,7 @@ static int map_table[] = {
 	[SD_OP_READ_OBJ] = SD_OP_READ_PEER,
 	[SD_OP_WRITE_OBJ] = SD_OP_WRITE_PEER,
 	[SD_OP_REMOVE_OBJ] = SD_OP_REMOVE_PEER,
+	[SD_OP_FLUSH_VDI] = SD_OP_FLUSH_PEER,
 };
 
 int gateway_to_peer_opcode(int opcode)
diff --git a/sheep/plain_store.c b/sheep/plain_store.c
index 26aa6dc..b72a55b 100644
--- a/sheep/plain_store.c
+++ b/sheep/plain_store.c
@@ -21,7 +21,7 @@ static char stale_dir[PATH_MAX];
 
 static int get_open_flags(uint64_t oid, bool create)
 {
-	int flags = O_DSYNC | O_RDWR;
+	int flags = O_RDWR;
 
 	if (is_data_obj(oid))
 		flags |= O_DIRECT;
@@ -29,6 +29,9 @@ static int get_open_flags(uint64_t oid, bool create)
 	if (create)
 		flags |= O_CREAT | O_TRUNC;
 
+	if (!sys->store_writeback)
+		flags |= O_DSYNC;
+
 	return flags;
 }
 
diff --git a/sheep/sheep.c b/sheep/sheep.c
index 10c0501..77e8d7c 100644
--- a/sheep/sheep.c
+++ b/sheep/sheep.c
@@ -52,10 +52,11 @@ static struct option const long_options[] = {
 	{"enable-cache", required_argument, NULL, 'w'},
 	{"zone", required_argument, NULL, 'z'},
 	{"pidfile", required_argument, NULL, 'P'},
+	{"writeback", no_argument, NULL, 'W'},
 	{NULL, 0, NULL, 0},
 };
 
-static const char *short_options = "c:dDfghl:op:P:s:w:y:z:";
+static const char *short_options = "c:dDfghl:op:P:s:w:y:z:W";
 
 static void usage(int status)
 {
@@ -81,6 +82,7 @@ Options:\n\
   -w, --enable-cache      enable object cache and specify the max size (M) and mode\n\
   -y, --myaddr            specify the address advertised to other sheep\n\
   -z, --zone              specify the zone id\n\
+  -W, --writeback         use writeback semantics in backend store\n\
 ", PACKAGE_VERSION, program_name);
 	exit(status);
 }
@@ -312,6 +314,9 @@ int main(int argc, char **argv)
 
 			sys->cdrv_option = get_cdrv_option(sys->cdrv, optarg);
 			break;
+		case 'W':
+			sys->store_writeback = 1;
+			break;
 		case 'h':
 			usage(0);
 			break;
diff --git a/sheep/sheep_priv.h b/sheep/sheep_priv.h
index 90006f6..9575504 100644
--- a/sheep/sheep_priv.h
+++ b/sheep/sheep_priv.h
@@ -119,6 +119,8 @@ struct cluster_info {
 	struct work_queue *block_wqueue;
 	struct work_queue *sockfd_wqueue;
 	struct work_queue *reclaim_wqueue;
+
+	int store_writeback;
 };
 
 struct siocb {
@@ -343,6 +345,11 @@ static inline int vnode_is_local(struct sd_vnode *v)
 	return is_myself(v->nid.addr, v->nid.port);
 }
 
+static inline int node_is_local(struct sd_node *n)
+{
+	return is_myself(n->nid.addr, n->nid.port);
+}
+
 /* gateway operations */
 int gateway_read_obj(struct request *req);
 int gateway_write_obj(struct request *req);
@@ -354,6 +361,7 @@ int peer_read_obj(struct request *req);
 int peer_write_obj(struct request *req);
 int peer_create_and_write_obj(struct request *req);
 int peer_remove_obj(struct request *req);
+int peer_flush(struct request *req);
 
 /* object_cache */
 
@@ -386,4 +394,6 @@ struct sockfd *sheep_get_sockfd(struct node_id *);
 void sheep_put_sockfd(struct node_id *, struct sockfd *);
 void sheep_del_sockfd(struct node_id *, struct sockfd *);
 
+int _peer_flush(void);
+
 #endif
-- 
1.7.5.1

