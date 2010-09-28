Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0I1SHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:07:37 -0400
Received: from comms2.zx.nl ([194.187.76.142]:51756 "EHLO comms2.zx.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab0I1SHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:07:36 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 14:07:36 EDT
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Mjd0Uoeop2fFlWQuLWmH/A)"
Subject: Re: [uml-devel] [REGRESSION] um: ubd: block layer issue (Was: ext3
 filesystem corruption in user mode linux)
From: Janjaap Bos <janjaap@bos.nl>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: tj@kernel.org, axboe@kernel.dk, mike.miller@hp.com,
        user-mode-linux-devel@lists.sourceforge.net, adrian@mcmen.demon.co.uk,
        jdike@addtoit.com, LKML <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca, Geert.Uytterhoeven@sonycom.com,
        Chris Frey <cdfrey@foursquare.net>
In-reply-to: <AANLkTi=PTp7YW_eYxtF-H2QSxgei3whWH59wU0C9oCkz@mail.gmail.com>
References: <AANLkTi=PTp7YW_eYxtF-H2QSxgei3whWH59wU0C9oCkz@mail.gmail.com>
Date: Tue, 28 Sep 2010 19:07:28 +0200
Message-id: <1285693648.14518.7.camel@voyager>
X-Mailer: Evolution 2.28.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary_(ID_Mjd0Uoeop2fFlWQuLWmH/A)
Content-type: text/plain; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT

See attached patch, and earlier message posted in March 2010 on uml user
list. We are out of maintainer...

Best,

-Janjaap



On Tue, 2010-09-28 at 18:16 +0200, richard -rw- weinberger wrote:
> Hi Tejun!
> 
> Chris Frey ran into some problems with ext3 on UML.
> See: http://marc.info/?i=20100924041410.GA18040%20()%20foursquare%20!%20net
> 
> I can reproduce this issue with any file system on Linux >= 2.6.31.
> There seems to be a serious problem with the block layer on UML.
> Under high load any file system gets corrupted.
> 
> The regression was most likely introduced with this three changes:
> 83096ebf1263b2c1ee5e653ba37d993d02e3eb7b (block: convert to pos and
> nr_sectors accessors)
> f81f2f7c9fee307e371f37424577d46f9eaf8692 (ubd: drop unnecessary
> rq->sector manipulation)
> 4d6c84d91d1a539ebc47d1a36a35e9390ba11fdc (ubd: cleanup completion path)
> 
> Maybe only f81f2f7 is the bad one. They depend on each and I don't
> know all the internals...
> 


--Boundary_(ID_Mjd0Uoeop2fFlWQuLWmH/A)
Content-type: text/x-patch; CHARSET=US-ASCII; name=v2.6.33.diff
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=v2.6.33.diff

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index cf8a97f..a529c3f 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -305,10 +305,12 @@ int line_ioctl(struct tty_struct *tty, struct file * file,
 		for (i = 0; i < ARRAY_SIZE(tty_ioctls); i++)
 			if (cmd == tty_ioctls[i].cmd)
 				break;
+#ifdef DEBUG
 		if (i == ARRAY_SIZE(tty_ioctls)) {
 			printk(KERN_ERR "%s: %s: unknown ioctl: 0x%x\n",
 			       __func__, tty->name, cmd);
 		}
+#endif
 		ret = -ENOIOCTLCMD;
 		break;
 	}
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 5ff5546..655ed9e 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -746,8 +746,12 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 	}
 	ubd_dev->fd = fd;
 
+	/* A setting higher than 1 sector currently (v2.6.33) generates
+	data loss, both for raw and cow ubd. */
+	blk_queue_max_sectors(ubd_dev->queue, 1 * sizeof(long));
+	blk_queue_max_phys_segments(ubd_dev->queue, 1 * sizeof(long));
+
 	if(ubd_dev->cow.file != NULL){
-		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 
 		err = -ENOMEM;
 		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
@@ -1223,7 +1227,7 @@ static void do_ubd_request(struct request_queue *q)
 	struct io_thread_req *io_req;
 	struct request *req;
 	sector_t sector;
-	int n;
+	int n, last_sectors;
 
 	while(1){
 		struct ubd *dev = q->queuedata;
@@ -1239,9 +1243,12 @@ static void do_ubd_request(struct request_queue *q)
 
 		req = dev->request;
 		sector = blk_rq_pos(req);
+		last_sectors = 0;
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
+			sector += last_sectors;
+			last_sectors = 0;
 			io_req = kmalloc(sizeof(struct io_thread_req),
 					 GFP_ATOMIC);
 			if(io_req == NULL){
@@ -1253,7 +1260,7 @@ static void do_ubd_request(struct request_queue *q)
 					(unsigned long long)sector << 9,
 					sg->offset, sg->length, sg_page(sg));
 
-			sector += sg->length >> 9;
+			last_sectors = sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
 					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 7fcad58..0731311 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -50,8 +50,20 @@ SECTIONS
   .rela.got       : { *(.rela.got) }
   .rel.bss        : { *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*) }
   .rela.bss       : { *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*) }
-  .rel.plt        : { *(.rel.plt) }
-  .rela.plt       : { *(.rela.plt) }
+  .rel.plt        :
+  {
+    *(.rel.plt)
+    PROVIDE_HIDDEN (__rel_iplt_start = .);
+    *(.rel.iplt)
+    PROVIDE_HIDDEN (__rel_iplt_end = .);
+  }
+  .rela.plt       :
+  {
+    *(.rela.plt)
+    PROVIDE_HIDDEN (__rela_iplt_start = .);
+    *(.rela.iplt)
+    PROVIDE_HIDDEN (__rela_iplt_end = .);
+  }
   .init           : {
     KEEP (*(.init))
   } =0x90909090
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index e7a6cca..a658604 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -36,6 +36,21 @@ SECTIONS
     *(.gnu.linkonce.t*)
   }
 
+  .rel.plt        :
+  {
+    *(.rel.plt)
+    PROVIDE_HIDDEN (__rel_iplt_start = .);
+    *(.rel.iplt)
+    PROVIDE_HIDDEN (__rel_iplt_end = .);
+  }
+  .rela.plt       :
+  {
+    *(.rela.plt)
+    PROVIDE_HIDDEN (__rela_iplt_start = .);
+    *(.rela.iplt)
+    PROVIDE_HIDDEN (__rela_iplt_end = .);
+  }
+
   . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
 	__syscall_stub_start = .;
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86_64/ptrace.c
index f3458d7..1c738c7 100644
--- a/arch/um/sys-x86_64/ptrace.c
+++ b/arch/um/sys-x86_64/ptrace.c
@@ -69,7 +69,7 @@ int poke_user(struct task_struct *child, long addr, long data)
 	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
 		(addr <= offsetof(struct user, u_debugreg[7]))) {
 		addr -= offsetof(struct user, u_debugreg[0]);
-		addr = addr >> 2;
+		addr = addr >> 3; // long is 8 bytes on x86_64
 		if ((addr == 4) || (addr == 5))
 			return -EIO;
 		child->thread.arch.debugregs[addr] = data;
@@ -114,7 +114,7 @@ int peek_user(struct task_struct *child, long addr, long data)
 	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
 		(addr <= offsetof(struct user, u_debugreg[7]))) {
 		addr -= offsetof(struct user, u_debugreg[0]);
-		addr = addr >> 2;
+		addr = addr >> 3; // long is 8 bytes on x86_64
 		tmp = child->thread.arch.debugregs[addr];
 	}
 	return put_user(tmp, (unsigned long *) data);

--Boundary_(ID_Mjd0Uoeop2fFlWQuLWmH/A)--
