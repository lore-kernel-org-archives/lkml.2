Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1HIL66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:58:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57874 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1HIL65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <1312890773-15305-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1312890773-15305-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 9 Aug 2011 14:58:55 +0300
X-Google-Sender-Auth: oXPIZEhqzNBoJrNGa_tEN-Mgm0Y
Message-ID: <CAOJsxLHDg8+QUFu68NBQoq8EgrgapTE15sFXQucw+pyDXV0tLQ@mail.gmail.com>
Subject: Re: [PATCH] net/9p: Convert net/9p protocol dumps to tracepoints
From: Pekka Enberg <penberg@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 2:52 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> This helps in more control over debugging.
>
> root@qemu-img-64:~# ls -al /pass/1234
> ls: cannot access /pass/1234: No such file or directory
> root@qemu-img-64:~# cat /sys/kernel/debug/tracing/trace
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>              ls-1585  [001]   152.525239: 9p_protocol_dump: clnt 18446612132802834432 P9_TWALK(tag = 1)
> 00000000: 17 00 00 00 6e 01 00 01 00 00
> 00000020: 00 04 00 31 32 33 34 00 00 ff
>
>              ls-1585  [001]   152.525244: <stack trace>
>  => trace_9p_protocol_dump
>  => p9pdu_finalize
>  => p9_client_rpc
>  => p9_client_walk
>  => v9fs_vfs_lookup
>  => d_alloc_and_lookup
>  => walk_component
>  => path_lookupat
>              ls-1585  [000]   152.526272: 9p_protocol_dump: clnt 18446612132802834432 P9_RLERROR(tag = 1)
> 00000000: 0b 00 00 00 07 01 00 02 00 00
> 00000020: 00 00 00 00 03 00 02 00 00 00
>
>              ls-1585  [000]   152.526275: <stack trace>
>  => trace_9p_protocol_dump
>  => p9_client_rpc
>  => p9_client_walk
>  => v9fs_vfs_lookup
>  => d_alloc_and_lookup
>  => walk_component
>  => path_lookupat
>  => do_path_lookup
>
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Wow, cool!

Acked-by: Pekka Enberg <penberg@kernel.org>

I'm CC'ing Ingo and Steven in case they want to review how you used
tracepoints here.

> ---
>  fs/9p/vfs_dir.c           |   12 ++--
>  include/net/9p/9p.h       |    3 -
>  include/net/9p/client.h   |    6 +-
>  include/trace/events/9p.h |  174 +++++++++++++++++++++++++++++++++++++++++++++
>  net/9p/client.c           |   70 +++++++++++--------
>  net/9p/protocol.c         |   53 +++-----------
>  net/9p/protocol.h         |    3 +-
>  7 files changed, 236 insertions(+), 85 deletions(-)
>  create mode 100644 include/trace/events/9p.h
>
> diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
> index ce6600f..598fff1 100644
> --- a/fs/9p/vfs_dir.c
> +++ b/fs/9p/vfs_dir.c
> @@ -165,9 +165,8 @@ static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
>                }
>                while (rdir->head < rdir->tail) {
>                        p9stat_init(&st);
> -                       err = p9stat_read(rdir->buf + rdir->head,
> -                                               rdir->tail - rdir->head, &st,
> -                                               fid->clnt->proto_version);
> +                       err = p9stat_read(fid->clnt, rdir->buf + rdir->head,
> +                                         rdir->tail - rdir->head, &st);
>                        if (err) {
>                                P9_DPRINTK(P9_DEBUG_VFS, "returned %d\n", err);
>                                err = -EIO;
> @@ -241,10 +240,9 @@ static int v9fs_dir_readdir_dotl(struct file *filp, void *dirent,
>
>                while (rdir->head < rdir->tail) {
>
> -                       err = p9dirent_read(rdir->buf + rdir->head,
> -                                               rdir->tail - rdir->head,
> -                                               &curdirent,
> -                                               fid->clnt->proto_version);
> +                       err = p9dirent_read(fid->clnt, rdir->buf + rdir->head,
> +                                           rdir->tail - rdir->head,
> +                                           &curdirent);
>                        if (err < 0) {
>                                P9_DPRINTK(P9_DEBUG_VFS, "returned %d\n", err);
>                                err = -EIO;
> diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
> index 2063a34..289b0ec 100644
> --- a/include/net/9p/9p.h
> +++ b/include/net/9p/9p.h
> @@ -76,11 +76,8 @@ do {  \
>        } \
>  } while (0)
>
> -#define P9_DUMP_PKT(way, pdu) p9pdu_dump(way, pdu)
> -
>  #else
>  #define P9_DPRINTK(level, format, arg...)  do { } while (0)
> -#define P9_DUMP_PKT(way, pdu) do { } while (0)
>  #endif
>
>
> diff --git a/include/net/9p/client.h b/include/net/9p/client.h
> index 55ce72c..5d07e53 100644
> --- a/include/net/9p/client.h
> +++ b/include/net/9p/client.h
> @@ -240,8 +240,8 @@ int p9_client_read(struct p9_fid *fid, char *data, char __user *udata,
>  int p9_client_write(struct p9_fid *fid, char *data, const char __user *udata,
>                                                        u64 offset, u32 count);
>  int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset);
> -int p9dirent_read(char *buf, int len, struct p9_dirent *dirent,
> -                                                       int proto_version);
> +int p9dirent_read(struct p9_client *clnt, char *buf, int len,
> +                 struct p9_dirent *dirent);
>  struct p9_wstat *p9_client_stat(struct p9_fid *fid);
>  int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst);
>  int p9_client_setattr(struct p9_fid *fid, struct p9_iattr_dotl *attr);
> @@ -259,7 +259,7 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *, u16);
>  void p9_client_cb(struct p9_client *c, struct p9_req_t *req);
>
>  int p9_parse_header(struct p9_fcall *, int32_t *, int8_t *, int16_t *, int);
> -int p9stat_read(char *, int, struct p9_wstat *, int);
> +int p9stat_read(struct p9_client *, char *, int, struct p9_wstat *);
>  void p9stat_free(struct p9_wstat *);
>
>  int p9_is_proto_dotu(struct p9_client *clnt);
> diff --git a/include/trace/events/9p.h b/include/trace/events/9p.h
> new file mode 100644
> index 0000000..ff5f16a
> --- /dev/null
> +++ b/include/trace/events/9p.h
> @@ -0,0 +1,174 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM 9p
> +
> +#if !defined(_TRACE_9P_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_9P_H
> +
> +#include <linux/tracepoint.h>
> +
> +/*
> + * ideally this should be NAME_MAX for path names. But i guess
> + * that will take too much space in trace buffer ?
> + */
> +#define TRACE_9P_STR_LEN 32
> +
> +#define show_9p_op(type)                                               \
> +       __print_symbolic(type,                                          \
> +                        { P9_TLERROR,          "P9_TLERROR" },         \
> +                        { P9_RLERROR,          "P9_RLERROR" },         \
> +                        { P9_TSTATFS,          "P9_TSTATFS" },         \
> +                        { P9_RSTATFS,          "P9_RSTATFS" },         \
> +                        { P9_TLOPEN,           "P9_TLOPEN" },          \
> +                        { P9_RLOPEN,           "P9_RLOPEN" },          \
> +                        { P9_TLCREATE,         "P9_TLCREATE" },        \
> +                        { P9_RLCREATE,         "P9_RLCREATE" },        \
> +                        { P9_TSYMLINK,         "P9_TSYMLINK" },        \
> +                        { P9_RSYMLINK,         "P9_RSYMLINK" },        \
> +                        { P9_TMKNOD,           "P9_TMKNOD" },          \
> +                        { P9_RMKNOD,           "P9_RMKNOD" },          \
> +                        { P9_TRENAME,          "P9_TRENAME" },         \
> +                        { P9_RRENAME,          "P9_RRENAME" },         \
> +                        { P9_TREADLINK,        "P9_TREADLINK" },       \
> +                        { P9_RREADLINK,        "P9_RREADLINK" },       \
> +                        { P9_TGETATTR,         "P9_TGETATTR" },        \
> +                        { P9_RGETATTR,         "P9_RGETATTR" },        \
> +                        { P9_TSETATTR,         "P9_TSETATTR" },        \
> +                        { P9_RSETATTR,         "P9_RSETATTR" },        \
> +                        { P9_TXATTRWALK,       "P9_TXATTRWALK" },      \
> +                        { P9_RXATTRWALK,       "P9_RXATTRWALK" },      \
> +                        { P9_TXATTRCREATE,     "P9_TXATTRCREATE" },    \
> +                        { P9_RXATTRCREATE,     "P9_RXATTRCREATE" },    \
> +                        { P9_TREADDIR,         "P9_TREADDIR" },        \
> +                        { P9_RREADDIR,         "P9_RREADDIR" },        \
> +                        { P9_TFSYNC,           "P9_TFSYNC" },          \
> +                        { P9_RFSYNC,           "P9_RFSYNC" },          \
> +                        { P9_TLOCK,            "P9_TLOCK" },           \
> +                        { P9_RLOCK,            "P9_RLOCK" },           \
> +                        { P9_TGETLOCK,         "P9_TGETLOCK" },        \
> +                        { P9_RGETLOCK,         "P9_RGETLOCK" },        \
> +                        { P9_TLINK,            "P9_TLINK" },           \
> +                        { P9_RLINK,            "P9_RLINK" },           \
> +                        { P9_TMKDIR,           "P9_TMKDIR" },          \
> +                        { P9_RMKDIR,           "P9_RMKDIR" },          \
> +                        { P9_TRENAMEAT,        "P9_TRENAMEAT" },       \
> +                        { P9_RRENAMEAT,        "P9_RRENAMEAT" },       \
> +                        { P9_TUNLINKAT,        "P9_TUNLINKAT" },       \
> +                        { P9_RUNLINKAT,        "P9_RUNLINKAT" },       \
> +                        { P9_TVERSION,         "P9_TVERSION" },        \
> +                        { P9_RVERSION,         "P9_RVERSION" },        \
> +                        { P9_TAUTH,            "P9_TAUTH" },           \
> +                        { P9_RAUTH,            "P9_RAUTH" },           \
> +                        { P9_TATTACH,          "P9_TATTACH" },         \
> +                        { P9_RATTACH,          "P9_RATTACH" },         \
> +                        { P9_TERROR,           "P9_TERROR" },          \
> +                        { P9_RERROR,           "P9_RERROR" },          \
> +                        { P9_TFLUSH,           "P9_TFLUSH" },          \
> +                        { P9_RFLUSH,           "P9_RFLUSH" },          \
> +                        { P9_TWALK,            "P9_TWALK" },           \
> +                        { P9_RWALK,            "P9_RWALK" },           \
> +                        { P9_TOPEN,            "P9_TOPEN" },           \
> +                        { P9_ROPEN,            "P9_ROPEN" },           \
> +                        { P9_TCREATE,          "P9_TCREATE" },         \
> +                        { P9_RCREATE,          "P9_RCREATE" },         \
> +                        { P9_TREAD,            "P9_TREAD" },           \
> +                        { P9_RREAD,            "P9_RREAD" },           \
> +                        { P9_TWRITE,           "P9_TWRITE" },          \
> +                        { P9_RWRITE,           "P9_RWRITE" },          \
> +                        { P9_TCLUNK,           "P9_TCLUNK" },          \
> +                        { P9_RCLUNK,           "P9_RCLUNK" },          \
> +                        { P9_TREMOVE,          "P9_TREMOVE" },         \
> +                        { P9_RREMOVE,          "P9_RREMOVE" },         \
> +                        { P9_TSTAT,            "P9_TSTAT" },           \
> +                        { P9_RSTAT,            "P9_RSTAT" },           \
> +                        { P9_TWSTAT,           "P9_TWSTAT" },          \
> +                        { P9_RWSTAT,           "P9_RWSTAT" })
> +
> +TRACE_EVENT(9p_client_req,
> +           TP_PROTO(struct p9_client *clnt, int8_t type, int tag),
> +
> +           TP_ARGS(clnt, type, tag),
> +
> +           TP_STRUCT__entry(
> +                   /*
> +                    * FIXME can i have void * as type. If so will it
> +                    * cause issue when i read trace from a 64 bit machine
> +                    * on a 32 bit machine.
> +                    */
> +                   __field(    __u64,          clnt                         )
> +                   __field(    __u8,           type                         )
> +                   __field(    __u32,          tag                          )
> +                   ),
> +
> +           TP_fast_assign(
> +                   __entry->clnt    =  (__u64)clnt;
> +                   __entry->type    =  type;
> +                   __entry->tag     =  tag;
> +                   ),
> +
> +           TP_printk("client %lu request %s tag  %d",
> +                   (long)__entry->clnt, show_9p_op(__entry->type),
> +                   __entry->tag)
> + );
> +
> +TRACE_EVENT(9p_client_res,
> +           TP_PROTO(struct p9_client *clnt, int8_t type, int tag, int err),
> +
> +           TP_ARGS(clnt, type, tag, err),
> +
> +           TP_STRUCT__entry(
> +                   /*
> +                    * FIXME can i have void * as type. If so will it
> +                    * cause issue when i read trace from a 64 bit machine
> +                    * on a 32 bit machine.
> +                    */
> +                   __field(    __u64,          clnt                         )
> +                   __field(    __u8,           type                         )
> +                   __field(    __u32,          tag                          )
> +                   __field(    __u32,          err                          )
> +                   ),
> +
> +           TP_fast_assign(
> +                   __entry->clnt    =  (__u64)clnt;
> +                   __entry->type    =  type;
> +                   __entry->tag     =  tag;
> +                   __entry->err     =  err;
> +                   ),
> +
> +           TP_printk("client %lu response %s tag  %d err %d",
> +                     (long)__entry->clnt, show_9p_op(__entry->type),
> +                     __entry->tag, __entry->err)
> +);
> +
> +TRACE_EVENT(9p_protocol_dump,
> +           TP_PROTO(struct p9_client *clnt, struct p9_fcall *pdu),
> +
> +           TP_ARGS(clnt, pdu),
> +
> +           TP_STRUCT__entry(
> +                   __field(    __u64,          clnt                    )
> +                   __field(    __u8,           type                    )
> +                   __field(    __u16,          tag                     )
> +                   __array(    unsigned char,  line1,          32      )
> +                   __array(    unsigned char,  line2,          32      )
> +                   ),
> +
> +           TP_fast_assign(
> +                   const u8 *ptr = pdu->sdata;
> +                   __entry->clnt   =  (__u64)clnt;
> +                   __entry->type   = pdu->id;
> +                   __entry->tag    = pdu->tag;
> +                   hex_dump_to_buffer(ptr, 16, 16,
> +                                      1, __entry->line1, 32, true);
> +                   hex_dump_to_buffer(ptr + 16, 16, 16,
> +                                      1, __entry->line2, 32, true);
> +                   ),
> +
> +           TP_printk("clnt %lu %s(tag = %d)\n%.8x: %s\n%.8x: %s\n",
> +                     (long)__entry->clnt, show_9p_op(__entry->type),
> +                     __entry->tag, 0, __entry->line1, 32 , __entry->line2)
> + );
> +
> +#endif /* _TRACE_9P_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/net/9p/client.c b/net/9p/client.c
> index d094ce9..ad1ab84 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -38,6 +38,9 @@
>  #include <net/9p/transport.h>
>  #include "protocol.h"
>
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/9p.h>
> +
>  /*
>   * Client Option Parsing (code inspired by NFS code)
>   *  - a little lazy - parse all client options
> @@ -703,8 +706,9 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
>        va_end(ap);
>        if (err)
>                goto reterr;
> -       p9pdu_finalize(req->tc);
> +       p9pdu_finalize(c, req->tc);
>
> +       trace_9p_client_req(c, type, tag);
>        err = c->trans_mod->request(c, req);
>        if (err < 0) {
>                if (err != -ERESTARTSYS && err != -EFAULT)
> @@ -746,14 +750,17 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
>                goto reterr;
>
>        err = p9_check_errors(c, req);
> +       /*
> +        * dump the response from server
> +        * This should be after check errors which poplulate pdu_fcall.
> +        */
> +       trace_9p_protocol_dump(c, req->rc);
> +       trace_9p_client_res(c, type, tag, err);
>        if (!err) {
>                P9_DPRINTK(P9_DEBUG_MUX, "exit: client %p op %d\n", c, type);
>                return req;
>        }
> -
>  reterr:
> -       P9_DPRINTK(P9_DEBUG_MUX, "exit: client %p op %d error: %d\n", c, type,
> -                                                                       err);
>        p9_free_req(c, req);
>        return ERR_PTR(err);
>  }
> @@ -823,7 +830,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
>        va_end(ap);
>        if (err)
>                goto reterr;
> -       p9pdu_finalize(req->tc);
> +       p9pdu_finalize(c, req->tc);
>
>        err = c->trans_mod->zc_request(c, req, uidata, uodata,
>                                       inlen, olen, in_hdrlen, kern_buf);
> @@ -857,10 +864,17 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
>                goto reterr;
>
>        err = p9_check_zc_errors(c, req, uidata, in_hdrlen, kern_buf);
> +       /*
> +        * dump the response from server
> +        * This should be after check errors which poplulate pdu_fcall.
> +        */
> +       trace_9p_protocol_dump(c, req->rc);
> +       trace_9p_client_res(c, type, tag, err);
>        if (!err) {
>                P9_DPRINTK(P9_DEBUG_MUX, "exit: client %p op %d\n", c, type);
>                return req;
>        }
> +
>  reterr:
>        P9_DPRINTK(P9_DEBUG_MUX, "exit: client %p op %d error: %d\n", c, type,
>                                                                        err);
> @@ -951,7 +965,7 @@ static int p9_client_version(struct p9_client *c)
>        err = p9pdu_readf(req->rc, c->proto_version, "ds", &msize, &version);
>        if (err) {
>                P9_DPRINTK(P9_DEBUG_9P, "version error %d\n", err);
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(c, req->rc);
>                goto error;
>        }
>
> @@ -1088,15 +1102,14 @@ EXPORT_SYMBOL(p9_client_begin_disconnect);
>  struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
>        char *uname, u32 n_uname, char *aname)
>  {
> -       int err;
> +       int err = 0;
>        struct p9_req_t *req;
>        struct p9_fid *fid;
>        struct p9_qid qid;
>
> -       P9_DPRINTK(P9_DEBUG_9P, ">>> TATTACH afid %d uname %s aname %s\n",
> -                                       afid ? afid->fid : -1, uname, aname);
> -       err = 0;
>
> +       P9_DPRINTK(P9_DEBUG_9P, ">>> TATTACH afid %d uname %s aname %s\n",
> +                  afid ? afid->fid : -1, uname, aname);
>        fid = p9_fid_create(clnt);
>        if (IS_ERR(fid)) {
>                err = PTR_ERR(fid);
> @@ -1113,7 +1126,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "Q", &qid);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                p9_free_req(clnt, req);
>                goto error;
>        }
> @@ -1173,7 +1186,7 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "R", &nwqids, &wqids);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                p9_free_req(clnt, req);
>                goto clunk_fid;
>        }
> @@ -1240,7 +1253,7 @@ int p9_client_open(struct p9_fid *fid, int mode)
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "Qd", &qid, &iounit);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto free_and_error;
>        }
>
> @@ -1283,7 +1296,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "Qd", qid, &iounit);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto free_and_error;
>        }
>
> @@ -1328,7 +1341,7 @@ int p9_client_fcreate(struct p9_fid *fid, char *name, u32 perm, int mode,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "Qd", &qid, &iounit);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto free_and_error;
>        }
>
> @@ -1367,7 +1380,7 @@ int p9_client_symlink(struct p9_fid *dfid, char *name, char *symtgt, gid_t gid,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "Q", qid);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto free_and_error;
>        }
>
> @@ -1558,12 +1571,11 @@ p9_client_read(struct p9_fid *fid, char *data, char __user *udata, u64 offset,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "D", &count, &dataptr);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto free_and_error;
>        }
>
>        P9_DPRINTK(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
> -       P9_DUMP_PKT(1, req->rc);
>
>        if (non_zc) {
>                if (data) {
> @@ -1633,7 +1645,7 @@ p9_client_write(struct p9_fid *fid, char *data, const char __user *udata,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "d", &count);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto free_and_error;
>        }
>
> @@ -1673,7 +1685,7 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "wS", &ignored, ret);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                p9_free_req(clnt, req);
>                goto error;
>        }
> @@ -1724,7 +1736,7 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "A", ret);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                p9_free_req(clnt, req);
>                goto error;
>        }
> @@ -1872,7 +1884,7 @@ int p9_client_statfs(struct p9_fid *fid, struct p9_rstatfs *sb)
>                &sb->bsize, &sb->blocks, &sb->bfree, &sb->bavail,
>                &sb->files, &sb->ffree, &sb->fsid, &sb->namelen);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                p9_free_req(clnt, req);
>                goto error;
>        }
> @@ -1979,7 +1991,7 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
>        }
>        err = p9pdu_readf(req->rc, clnt->proto_version, "q", attr_size);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                p9_free_req(clnt, req);
>                goto clunk_fid;
>        }
> @@ -2063,7 +2075,7 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "D", &count, &dataptr);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto free_and_error;
>        }
>
> @@ -2100,7 +2112,7 @@ int p9_client_mknod_dotl(struct p9_fid *fid, char *name, int mode,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "Q", qid);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto error;
>        }
>        P9_DPRINTK(P9_DEBUG_9P, "<<< RMKNOD qid %x.%llx.%x\n", qid->type,
> @@ -2131,7 +2143,7 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, char *name, int mode,
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "Q", qid);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto error;
>        }
>        P9_DPRINTK(P9_DEBUG_9P, "<<< RMKDIR qid %x.%llx.%x\n", qid->type,
> @@ -2166,7 +2178,7 @@ int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status)
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "b", status);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto error;
>        }
>        P9_DPRINTK(P9_DEBUG_9P, "<<< RLOCK status %i\n", *status);
> @@ -2199,7 +2211,7 @@ int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *glock)
>                        &glock->start, &glock->length, &glock->proc_id,
>                        &glock->client_id);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto error;
>        }
>        P9_DPRINTK(P9_DEBUG_9P, "<<< RGETLOCK type %i start %lld length %lld "
> @@ -2227,7 +2239,7 @@ int p9_client_readlink(struct p9_fid *fid, char **target)
>
>        err = p9pdu_readf(req->rc, clnt->proto_version, "s", target);
>        if (err) {
> -               P9_DUMP_PKT(1, req->rc);
> +               trace_9p_protocol_dump(clnt, req->rc);
>                goto error;
>        }
>        P9_DPRINTK(P9_DEBUG_9P, "<<< RREADLINK target %s\n", *target);
> diff --git a/net/9p/protocol.c b/net/9p/protocol.c
> index b7d4e8a..55e10a9 100644
> --- a/net/9p/protocol.c
> +++ b/net/9p/protocol.c
> @@ -37,40 +37,11 @@
>  #include <net/9p/client.h>
>  #include "protocol.h"
>
> +#include <trace/events/9p.h>
> +
>  static int
>  p9pdu_writef(struct p9_fcall *pdu, int proto_version, const char *fmt, ...);
>
> -#ifdef CONFIG_NET_9P_DEBUG
> -void
> -p9pdu_dump(int way, struct p9_fcall *pdu)
> -{
> -       int len = pdu->size;
> -
> -       if ((p9_debug_level & P9_DEBUG_VPKT) != P9_DEBUG_VPKT) {
> -               if ((p9_debug_level & P9_DEBUG_PKT) == P9_DEBUG_PKT) {
> -                       if (len > 32)
> -                               len = 32;
> -               } else {
> -                       /* shouldn't happen */
> -                       return;
> -               }
> -       }
> -
> -       if (way)
> -               print_hex_dump_bytes("[9P] ", DUMP_PREFIX_OFFSET, pdu->sdata,
> -                                                                       len);
> -       else
> -               print_hex_dump_bytes("]9P[ ", DUMP_PREFIX_OFFSET, pdu->sdata,
> -                                                                       len);
> -}
> -#else
> -void
> -p9pdu_dump(int way, struct p9_fcall *pdu)
> -{
> -}
> -#endif
> -EXPORT_SYMBOL(p9pdu_dump);
> -
>  void p9stat_free(struct p9_wstat *stbuf)
>  {
>        kfree(stbuf->name);
> @@ -551,7 +522,7 @@ p9pdu_writef(struct p9_fcall *pdu, int proto_version, const char *fmt, ...)
>        return ret;
>  }
>
> -int p9stat_read(char *buf, int len, struct p9_wstat *st, int proto_version)
> +int p9stat_read(struct p9_client *clnt, char *buf, int len, struct p9_wstat *st)
>  {
>        struct p9_fcall fake_pdu;
>        int ret;
> @@ -561,10 +532,10 @@ int p9stat_read(char *buf, int len, struct p9_wstat *st, int proto_version)
>        fake_pdu.sdata = buf;
>        fake_pdu.offset = 0;
>
> -       ret = p9pdu_readf(&fake_pdu, proto_version, "S", st);
> +       ret = p9pdu_readf(&fake_pdu, clnt->proto_version, "S", st);
>        if (ret) {
>                P9_DPRINTK(P9_DEBUG_9P, "<<< p9stat_read failed: %d\n", ret);
> -               P9_DUMP_PKT(0, &fake_pdu);
> +               trace_9p_protocol_dump(clnt, &fake_pdu);
>        }
>
>        return ret;
> @@ -577,7 +548,7 @@ int p9pdu_prepare(struct p9_fcall *pdu, int16_t tag, int8_t type)
>        return p9pdu_writef(pdu, 0, "dbw", 0, type, tag);
>  }
>
> -int p9pdu_finalize(struct p9_fcall *pdu)
> +int p9pdu_finalize(struct p9_client *clnt, struct p9_fcall *pdu)
>  {
>        int size = pdu->size;
>        int err;
> @@ -586,7 +557,7 @@ int p9pdu_finalize(struct p9_fcall *pdu)
>        err = p9pdu_writef(pdu, 0, "d", size);
>        pdu->size = size;
>
> -       P9_DUMP_PKT(0, pdu);
> +       trace_9p_protocol_dump(clnt, pdu);
>        P9_DPRINTK(P9_DEBUG_9P, ">>> size=%d type: %d tag: %d\n", pdu->size,
>                                                        pdu->id, pdu->tag);
>
> @@ -599,8 +570,8 @@ void p9pdu_reset(struct p9_fcall *pdu)
>        pdu->size = 0;
>  }
>
> -int p9dirent_read(char *buf, int len, struct p9_dirent *dirent,
> -                                               int proto_version)
> +int p9dirent_read(struct p9_client *clnt, char *buf, int len,
> +                 struct p9_dirent *dirent)
>  {
>        struct p9_fcall fake_pdu;
>        int ret;
> @@ -611,11 +582,11 @@ int p9dirent_read(char *buf, int len, struct p9_dirent *dirent,
>        fake_pdu.sdata = buf;
>        fake_pdu.offset = 0;
>
> -       ret = p9pdu_readf(&fake_pdu, proto_version, "Qqbs", &dirent->qid,
> -                       &dirent->d_off, &dirent->d_type, &nameptr);
> +       ret = p9pdu_readf(&fake_pdu, clnt->proto_version, "Qqbs", &dirent->qid,
> +                         &dirent->d_off, &dirent->d_type, &nameptr);
>        if (ret) {
>                P9_DPRINTK(P9_DEBUG_9P, "<<< p9dirent_read failed: %d\n", ret);
> -               P9_DUMP_PKT(1, &fake_pdu);
> +               trace_9p_protocol_dump(clnt, &fake_pdu);
>                goto out;
>        }
>
> diff --git a/net/9p/protocol.h b/net/9p/protocol.h
> index e5083f3..b0a6aa8f 100644
> --- a/net/9p/protocol.h
> +++ b/net/9p/protocol.h
> @@ -29,8 +29,7 @@ int p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
>                                                                va_list ap);
>  int p9pdu_readf(struct p9_fcall *pdu, int proto_version, const char *fmt, ...);
>  int p9pdu_prepare(struct p9_fcall *pdu, int16_t tag, int8_t type);
> -int p9pdu_finalize(struct p9_fcall *pdu);
> -void p9pdu_dump(int, struct p9_fcall *);
> +int p9pdu_finalize(struct p9_client *clnt, struct p9_fcall *pdu);
>  void p9pdu_reset(struct p9_fcall *pdu);
>  size_t pdu_read(struct p9_fcall *pdu, void *data, size_t size);
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
