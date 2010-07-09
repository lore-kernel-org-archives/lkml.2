Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab0GIROs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:14:48 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:52522 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab0GIROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:14:46 -0400
X-MXL-Hash: 4c37590603c78348-bc18bf914f65ea68209b822022fee812872aba5a
X-MXL-Hash: 4c3758f26c27ab5a-b5b9fa7e60959141e2cf2cee3a3972f185b47c59
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: use the fbuffer pointer instead of looking it up
Date: Fri, 9 Jul 2010 10:13:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007091013.36589.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.98]
X-AnalysisOut: [v=1.0 c=1 a=pvTmzDSUmJQA:10 a=Lw_SFsgOoS4A:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=ElGhtKrHx9xWGnZ8pakA:9 a=jehWDJRh_yrti0XXbp]
X-AnalysisOut: [oA:7 a=BDKT_JbB0dr2DvUlIMShLOvU6c8A:4 a=QEXdDO2ut3YA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10 a=QuWgELgJaZMtq9H_:21 a=]
X-AnalysisOut: [T1NKxQZT_bE921fP:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of passing the minor number and having to look up the fbuffer, just
pass the fbuffer directly to the buffer management code.

Also, to make the code more consistent, change the push_empty() call so
that the fbuffer is passed as the first parameter.

Prototype the printques routine to avoid having to declare it as extern.

Cleanup some of the comments in dt3155_isr.h.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index fed7e62..091eb74 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -55,8 +55,6 @@ MA 02111-1307 USA
 
 */
 
-extern void printques(int);
-
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
@@ -329,25 +327,25 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 	  local_irq_disable();
 
 #ifdef DEBUG_QUES_B
-	  printques(minor);
+	  printques(fb);
 #endif
 	  if (fb->nbuffers > 2)
 	    {
-	      if (!are_empty_buffers(minor))
+	      if (!are_empty_buffers(fb))
 		{
 		  /* The number of active + locked buffers is
 		   * at most 2, and since there are none empty, there
 		   * must be at least nbuffers-2 ready buffers.
 		   * This is where we 'drop frames', oldest first. */
-		  push_empty(pop_ready(minor),  minor);
+		  push_empty(fb, pop_ready(fb));
 		}
 
 	      /* The ready_que can't be full, since we know
 	       * there is one active buffer right now, so it's safe
 	       * to push the active buf on the ready_que. */
-	      push_ready(minor, fb->active_buf);
+	      push_ready(fb, fb->active_buf);
 	      /* There's at least 1 empty -- make it active */
-	      fb->active_buf = pop_empty(minor);
+	      fb->active_buf = pop_empty(fb);
 	      fb->frame_info[fb->active_buf].tag = ++unique_tag;
 	    }
 	  else /* nbuffers == 2, special case */
@@ -357,20 +355,20 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 	       */
 	      if (fb->locked_buf < 0)
 		{
-		  push_ready(minor, fb->active_buf);
-		  if (are_empty_buffers(minor))
+		  push_ready(fb, fb->active_buf);
+		  if (are_empty_buffers(fb))
 		    {
-		      fb->active_buf = pop_empty(minor);
+		      fb->active_buf = pop_empty(fb);
 		    }
 		  else
 		    { /* no empty or locked buffers, so use a readybuf */
-		      fb->active_buf = pop_ready(minor);
+		      fb->active_buf = pop_ready(fb);
 		    }
 		}
 	    }
 
 #ifdef DEBUG_QUES_B
-	  printques(minor);
+	  printques(fb);
 #endif
 
 	  fb->even_happened = 0;
@@ -559,7 +557,7 @@ static int dt3155_ioctl(struct inode *inode,
       {
 	if (dts->state != DT3155_STATE_IDLE)
 	  return -EBUSY;
-	return dt3155_flush(minor);
+	return dt3155_flush(fb);
       }
     case DT3155_STOP:
       {
@@ -669,6 +667,7 @@ static int dt3155_open(struct inode* inode, struct file* filep)
 {
   int minor = MINOR(inode->i_rdev); /* what device are we opening? */
   struct dt3155_status *dts = &dt3155_status[minor];
+  struct dt3155_fbuffer *fb = &dts->fbuffer;
 
   if (dt3155_dev_open[minor]) {
     printk ("DT3155:  Already opened by another process.\n");
@@ -692,7 +691,7 @@ static int dt3155_open(struct inode* inode, struct file* filep)
 
   dt3155_dev_open[minor] = 1 ;
 
-  dt3155_flush(minor);
+  dt3155_flush(fb);
 
   /* Disable ALL interrupts */
   writel(0, dt3155_lbase[minor] + INT_CSR);
@@ -767,9 +766,9 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   /* non-blocking reads should return if no data */
   if (filep->f_flags & O_NDELAY)
     {
-      if ((frame_index = dt3155_get_ready_buffer(minor)) < 0) {
-	/*printk("dt3155:  no buffers available (?)\n");*/
-	/* 		printques(minor); */
+      if ((frame_index = dt3155_get_ready_buffer(fb)) < 0) {
+	/* printk("dt3155:  no buffers available (?)\n"); */
+	/* printques(fb); */
 	return -EAGAIN;
       }
     }
@@ -780,15 +779,14 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
        * Note that wait_event_interruptible() does not actually
        * sleep/wait if it's condition evaluates to true upon entry.
        */
-      wait_event_interruptible(dt3155_read_wait_queue[minor],
-			       (frame_index = dt3155_get_ready_buffer(minor))
-			       >= 0);
+      frame_index = dt3155_get_ready_buffer(fb);
+      wait_event_interruptible(dt3155_read_wait_queue[minor], frame_index >= 0);
 
       if (frame_index < 0)
 	{
 	  printk ("DT3155: read: interrupted\n");
 	  quick_stop (minor);
-	  printques(minor);
+	  printques(fb);
 	  return -EINTR;
 	}
     }
@@ -813,8 +811,10 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
 {
   int minor = MINOR(filp->f_dentry->d_inode->i_rdev);
+  struct dt3155_status *dts = &dt3155_status[minor];
+  struct dt3155_fbuffer *fb = &dts->fbuffer;
 
-  if (!is_ready_buf_empty(minor))
+  if (!is_ready_buf_empty(fb))
     return POLLIN | POLLRDNORM;
 
   poll_wait (filp, &dt3155_read_wait_queue[minor], wait);
diff --git a/drivers/staging/dt3155/dt3155_isr.c b/drivers/staging/dt3155/dt3155_isr.c
index 01ab888..549186f 100644
--- a/drivers/staging/dt3155/dt3155_isr.c
+++ b/drivers/staging/dt3155/dt3155_isr.c
@@ -68,10 +68,8 @@ Purpose: Buffer management routines, and other routines for the ISR
 /***************************
  * are_empty_buffers
  ***************************/
-bool are_empty_buffers(int minor)
+bool are_empty_buffers(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-
 	return fb->empty_len;
 }
 
@@ -84,10 +82,8 @@ bool are_empty_buffers(int minor)
  * given by fb->empty_buffers[0].
  * empty_buffers should never fill up, though this is not checked.
  **************************/
-void push_empty(int index, int minor)
+void push_empty(struct dt3155_fbuffer *fb, int index)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-
 	fb->empty_buffers[fb->empty_len] = index;
 	fb->empty_len++;
 }
@@ -95,10 +91,8 @@ void push_empty(int index, int minor)
 /**************************
  * pop_empty
  **************************/
-int pop_empty(int minor)
+int pop_empty(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-
 	fb->empty_len--;
 	return fb->empty_buffers[fb->empty_len];
 }
@@ -106,10 +100,8 @@ int pop_empty(int minor)
 /*************************
  * is_ready_buf_empty
  *************************/
-bool is_ready_buf_empty(int minor)
+bool is_ready_buf_empty(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-
 	return fb->ready_len == 0;
 }
 
@@ -120,19 +112,16 @@ bool is_ready_buf_empty(int minor)
  * buffers, since it corresponds to nbuffers ready buffers!!
  * 7/31/02: total rewrite. --NJC
  *************************/
-bool is_ready_buf_full(int minor)
+bool is_ready_buf_full(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-
 	return fb->ready_len == fb->nbuffers;
 }
 
 /*****************************************************
  * push_ready
  *****************************************************/
-void push_ready(int minor, int index)
+void push_ready(struct dt3155_fbuffer *fb, int index)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 	int head = fb->ready_head;
 
 	fb->ready_que[head] = index;
@@ -145,10 +134,8 @@ void push_ready(int minor, int index)
  *
  * Simply comptutes the tail given the head and the length.
  *****************************************************/
-static int get_tail(int minor)
+static int get_tail(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-
 	return (fb->ready_head - fb->ready_len + fb->nbuffers) % fb->nbuffers;
 }
 
@@ -158,10 +145,9 @@ static int get_tail(int minor)
  * This assumes that there is a ready buffer ready... should
  * be checked (e.g. with is_ready_buf_empty()  prior to call.
  *****************************************************/
-int pop_ready(int minor)
+int pop_ready(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-	int tail = get_tail(minor);
+	int tail = get_tail(fb);
 
 	fb->ready_len--;
 	return fb->ready_que[tail];
@@ -170,13 +156,12 @@ int pop_ready(int minor)
 /*****************************************************
  * printques
  *****************************************************/
-void printques(int minor)
+void printques(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 	int i;
 
 	printk(KERN_INFO "\n R:");
-	for (i = get_tail(minor); i != fb->ready_head; i++, i %= fb->nbuffers)
+	for (i = get_tail(fb); i != fb->ready_head; i++, i %= fb->nbuffers)
 		printk(" %d ", fb->ready_que[i]);
 
 	printk(KERN_INFO "\n E:");
@@ -349,14 +334,14 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
 		}
 
 		fb->frame_info[index].addr = rambuff_acm;
-		push_empty(index, minor);
+		push_empty(fb, index);
 		/* printk("  - Buffer : %lx\n", fb->frame_info[index].addr); */
 		fb->nbuffers += 1;
 		rambuff_acm += bufsize;
 	}
 
 	/* Make sure there is an active buffer there. */
-	fb->active_buf    = pop_empty(minor);
+	fb->active_buf    = pop_empty(fb);
 	fb->even_happened = 0;
 	fb->even_stopped  = 0;
 
@@ -382,12 +367,10 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
  * The internal function for releasing a locked buffer.
  * It assumes interrupts are turned off.
  *****************************************************/
-static void internal_release_locked_buffer(int minor)
+static void internal_release_locked_buffer(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
-
 	if (fb->locked_buf >= 0) {
-		push_empty(fb->locked_buf, minor);
+		push_empty(fb, fb->locked_buf);
 		fb->locked_buf = -1;
 	}
 }
@@ -397,36 +380,35 @@ static void internal_release_locked_buffer(int minor)
  *
  * The user function of the above.
  *****************************************************/
-void dt3155_release_locked_buffer(int minor)
+void dt3155_release_locked_buffer(struct dt3155_fbuffer *fb)
 {
 	unsigned long int flags;
 
 	local_save_flags(flags);
 	local_irq_disable();
-	internal_release_locked_buffer(minor);
+	internal_release_locked_buffer(fb);
 	local_irq_restore(flags);
 }
 
 /*****************************************************
  * dt3155_flush
  *****************************************************/
-int dt3155_flush(int minor)
+int dt3155_flush(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 	unsigned long int flags;
 	int index;
 
 	local_save_flags(flags);
 	local_irq_disable();
 
-	internal_release_locked_buffer(minor);
+	internal_release_locked_buffer(fb);
 	fb->empty_len = 0;
 
 	for (index = 0; index < fb->nbuffers; index++)
-		push_empty(index, minor);
+		push_empty(fb, index);
 
 	/* Make sure there is an active buffer there. */
-	fb->active_buf = pop_empty(minor);
+	fb->active_buf = pop_empty(fb);
 
 	fb->even_happened = 0;
 	fb->even_stopped  = 0;
@@ -448,9 +430,8 @@ int dt3155_flush(int minor)
  * If the user has a buffer locked it will unlock
  * that buffer before returning the new one.
  *****************************************************/
-int dt3155_get_ready_buffer(int minor)
+int dt3155_get_ready_buffer(struct dt3155_fbuffer *fb)
 {
-	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 	unsigned long int flags;
 	int frame_index;
 
@@ -458,20 +439,20 @@ int dt3155_get_ready_buffer(int minor)
 	local_irq_disable();
 
 #ifdef DEBUG_QUES_A
-	printques(minor);
+	printques(fb);
 #endif
 
-	internal_release_locked_buffer(minor);
+	internal_release_locked_buffer(fb);
 
-	if (is_ready_buf_empty(minor)) {
+	if (is_ready_buf_empty(fb)) {
 		frame_index = -1;
 	} else {
-		frame_index = pop_ready(minor);
+		frame_index = pop_ready(fb);
 		fb->locked_buf = frame_index;
-    }
+	}
 
 #ifdef DEBUG_QUES_B
-	printques(minor);
+	printques(fb);
 #endif
 
 	local_irq_restore(flags);
diff --git a/drivers/staging/dt3155/dt3155_isr.h b/drivers/staging/dt3155/dt3155_isr.h
index c4cf865..b9e922b 100644
--- a/drivers/staging/dt3155/dt3155_isr.h
+++ b/drivers/staging/dt3155/dt3155_isr.h
@@ -36,40 +36,48 @@ MA 02111-1307 USA
 #ifndef DT3155_ISR_H
 #define DT3155_ISR_H
 
-/* User functions for buffering */
-/* Initialize the buffering system.  This should */
-/* be called prior to enabling interrupts */
+/**********************************
+ * User functions for buffering
+ **********************************/
 
+/*
+ * Initialize the buffering system.
+ * This should be called prior to enabling interrupts
+ */
 u32 dt3155_setup_buffers(u32 *allocatorAddr);
 
-/* Get the next frame of data if it is ready.  Returns */
-/* zero if no data is ready.  If there is data but */
-/* the user has a locked buffer, it will unlock that */
-/* buffer and return it to the free list. */
-
-int dt3155_get_ready_buffer(int minor);
-
-/* Return a locked buffer to the free list */
+/*
+ * Get the next frame of data if it is ready.
+ * Returns zero if no data is ready.  If there is data but the user has a
+ * locked buffer, it will unlock that buffer and return it to the free list.
+ */
+int dt3155_get_ready_buffer(struct dt3155_fbuffer *fb);
 
-void dt3155_release_locked_buffer(int minor);
+/*
+ * Return a locked buffer to the free list.
+ */
+void dt3155_release_locked_buffer(struct dt3155_fbuffer *fb);
 
-/* Flush the buffer system */
-int dt3155_flush(int minor);
+/*
+ * Flush the buffer system.
+ */
+int dt3155_flush(struct dt3155_fbuffer *fb);
 
 /**********************************
  * Simple array based que struct
  **********************************/
 
-bool are_empty_buffers(int minor);
-void push_empty(int index, int minor);
+bool are_empty_buffers(struct dt3155_fbuffer *fb);
+void push_empty(struct dt3155_fbuffer *fb, int index);
 
-int  pop_empty(int minor);
+int pop_empty(struct dt3155_fbuffer *fb);
 
-bool is_ready_buf_empty(int minor);
-bool is_ready_buf_full(int minor);
+bool is_ready_buf_empty(struct dt3155_fbuffer *fb);
+bool is_ready_buf_full(struct dt3155_fbuffer *fb);
 
-void push_ready(int minor, int index);
-int  pop_ready(int minor);
+void push_ready(struct dt3155_fbuffer *fb, int index);
+int  pop_ready(struct dt3155_fbuffer *fb);
 
+void printques(struct dt3155_fbuffer *fb);
 
 #endif
