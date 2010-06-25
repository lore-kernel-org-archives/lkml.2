Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0FYWPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 18:15:25 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:39407 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab0FYWPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 18:15:24 -0400
X-MXL-Hash: 4c252a7c56526626-fb91a0d7a66c606bcaf67d74fefd95e3b82393ff
X-MXL-Hash: 4c252a7405940f44-fab274342c6f3be01a032734086685a102029432
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155_isr: cleanup fbuffer usage
Date: Fri, 25 Jun 2010 15:14:09 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201006251514.10068.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010062201)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.69]
X-AnalysisOut: [v=1.0 c=1 a=RBbIOdy3sXoA:10 a=GQCbJdZ--msA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=TYbMNos9eHUa9bm6/o8foQ==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=wCIZ4KZCfVhOQgzmrWQA:9 a=13QZuyY2NSucrWXymW]
X-AnalysisOut: [wA:7 a=JuI-TzFws7f0aEqaWCLvdn_3zVwA:4 a=QEXdDO2ut3YA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10 a=9L6me1kOj4S0VYNA:21 a=]
X-AnalysisOut: [OVQxRH25BIYmw65j:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that dt3155_drv.c is not dependent on the global symbol 
dt3155_fbuffer[], declared in dt3155_isr.c, remove it.

This also fixes many of the coding style problems in dt3155_isr.c.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_isr.c b/drivers/staging/dt3155/dt3155_isr.c
index 59b7bfd..01ab888 100644
--- a/drivers/staging/dt3155/dt3155_isr.c
+++ b/drivers/staging/dt3155/dt3155_isr.c
@@ -59,158 +59,133 @@ Purpose: Buffer management routines, and other routines for the ISR
 #define UPPER_10_BITS   (0x3FF<<22)  /* Can't DMA accross a 4MB boundary!*/
 
 
-/* Pointer into global structure for handling buffers */
-struct dt3155_fbuffer *dt3155_fbuffer[MAXBOARDS] = {NULL
-#if MAXBOARDS == 2
-						      , NULL
-#endif
-};
-
 /******************************************************************************
  * Simple array based que struct
  *
  * Some handy functions using the buffering structure.
  *****************************************************************************/
 
-
 /***************************
  * are_empty_buffers
- * m is minor # of device
  ***************************/
-bool are_empty_buffers(int m)
+bool are_empty_buffers(int minor)
 {
-  return dt3155_fbuffer[m]->empty_len;
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+
+	return fb->empty_len;
 }
 
 /**************************
  * push_empty
- * m is minor # of device
  *
  * This is slightly confusing.  The number empty_len is the literal #
  * of empty buffers.  After calling, empty_len-1 is the index into the
  * empty buffer stack.  So, if empty_len == 1, there is one empty buffer,
- * given by dt3155_fbuffer[m]->empty_buffers[0].
+ * given by fb->empty_buffers[0].
  * empty_buffers should never fill up, though this is not checked.
  **************************/
-void push_empty(int index, int m)
+void push_empty(int index, int minor)
 {
-  dt3155_fbuffer[m]->empty_buffers[dt3155_fbuffer[m]->empty_len] = index;
-  dt3155_fbuffer[m]->empty_len++;
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+
+	fb->empty_buffers[fb->empty_len] = index;
+	fb->empty_len++;
 }
 
 /**************************
- * pop_empty(m)
- * m is minor # of device
+ * pop_empty
  **************************/
-int pop_empty(int m)
+int pop_empty(int minor)
 {
-  dt3155_fbuffer[m]->empty_len--;
-  return dt3155_fbuffer[m]->empty_buffers[dt3155_fbuffer[m]->empty_len];
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+
+	fb->empty_len--;
+	return fb->empty_buffers[fb->empty_len];
 }
 
 /*************************
- * is_ready_buf_empty(m)
- * m is minor # of device
+ * is_ready_buf_empty
  *************************/
-bool is_ready_buf_empty(int m)
+bool is_ready_buf_empty(int minor)
 {
-  return ((dt3155_fbuffer[m]->ready_len) == 0);
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+
+	return fb->ready_len == 0;
 }
 
 /*************************
- * is_ready_buf_full(m)
- * m is minor # of device
+ * is_ready_buf_full
+ *
  * this should *never* be true if there are any active, locked or empty
  * buffers, since it corresponds to nbuffers ready buffers!!
  * 7/31/02: total rewrite. --NJC
  *************************/
-bool is_ready_buf_full(int m)
+bool is_ready_buf_full(int minor)
 {
-  return dt3155_fbuffer[m]->ready_len == dt3155_fbuffer[m]->nbuffers;
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+
+	return fb->ready_len == fb->nbuffers;
 }
 
 /*****************************************************
- * push_ready(m, buffer)
- * m is minor # of device
- *
+ * push_ready
  *****************************************************/
-void push_ready(int m, int index)
+void push_ready(int minor, int index)
 {
-  int head = dt3155_fbuffer[m]->ready_head;
-
-  dt3155_fbuffer[m]->ready_que[head] = index;
-  dt3155_fbuffer[m]->ready_head = ((head + 1) %
-				      (dt3155_fbuffer[m]->nbuffers));
-  dt3155_fbuffer[m]->ready_len++;
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+	int head = fb->ready_head;
 
+	fb->ready_que[head] = index;
+	fb->ready_head = (head + 1) % fb->nbuffers;
+	fb->ready_len++;
 }
 
 /*****************************************************
- * get_tail()
- * m is minor # of device
+ * get_tail
  *
  * Simply comptutes the tail given the head and the length.
  *****************************************************/
-static int get_tail(int m)
+static int get_tail(int minor)
 {
-	int ncount;
-	ncount = (dt3155_fbuffer[m]->ready_head -
-			dt3155_fbuffer[m]->ready_len +
-			dt3155_fbuffer[m]->nbuffers)%
-		(dt3155_fbuffer[m]->nbuffers);
-	return ncount;
-}
-
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 
+	return (fb->ready_head - fb->ready_len + fb->nbuffers) % fb->nbuffers;
+}
 
 /*****************************************************
- * pop_ready()
- * m is minor # of device
+ * pop_ready
  *
  * This assumes that there is a ready buffer ready... should
  * be checked (e.g. with is_ready_buf_empty()  prior to call.
  *****************************************************/
-int pop_ready(int m)
+int pop_ready(int minor)
 {
-  int tail;
-  tail = get_tail(m);
-  dt3155_fbuffer[m]->ready_len--;
-  return dt3155_fbuffer[m]->ready_que[tail];
-}
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+	int tail = get_tail(minor);
 
+	fb->ready_len--;
+	return fb->ready_que[tail];
+}
 
 /*****************************************************
  * printques
- * m is minor # of device
  *****************************************************/
-void printques(int m)
+void printques(int minor)
 {
-  int head = dt3155_fbuffer[m]->ready_head;
-  int tail;
-  int num = dt3155_fbuffer[m]->nbuffers;
-  int frame_index;
-  int index;
-
-  tail = get_tail(m);
-
-  printk(KERN_INFO "\n R:");
-    for (index = tail; index != head; index++, index = index % (num)) {
-	frame_index = dt3155_fbuffer[m]->ready_que[index];
-	printk(" %d ", frame_index);
-    }
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+	int i;
 
-  printk(KERN_INFO "\n E:");
-    for (index = 0; index < dt3155_fbuffer[m]->empty_len; index++) {
-	frame_index = dt3155_fbuffer[m]->empty_buffers[index];
-	printk(" %d ", frame_index);
-    }
+	printk(KERN_INFO "\n R:");
+	for (i = get_tail(minor); i != fb->ready_head; i++, i %= fb->nbuffers)
+		printk(" %d ", fb->ready_que[i]);
 
-  frame_index = dt3155_fbuffer[m]->active_buf;
-  printk(KERN_INFO "\n A: %d", frame_index);
+	printk(KERN_INFO "\n E:");
+	for (i = 0; i < fb->empty_len; i++)
+		printk(" %d ", fb->empty_buffers[i]);
 
-  frame_index = dt3155_fbuffer[m]->locked_buf;
-  printk(KERN_INFO "\n L: %d\n", frame_index);
+	printk(KERN_INFO "\n A: %d", fb->active_buf);
 
+	printk(KERN_INFO "\n L: %d\n", fb->locked_buf);
 }
 
 /*****************************************************
@@ -304,6 +279,7 @@ void allocate_buffers(u32 *buf_addr, u32* total_size_kbs,
 u32 dt3155_setup_buffers(u32 *allocatorAddr)
 
 {
+  struct dt3155_fbuffer *fb;
   u32 index;
   u32 rambuff_addr; /* start of allocation */
   u32 rambuff_size; /* total size allocated to driver */
@@ -312,18 +288,12 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
   u32 rambuff_end;  /* end of rambuff */
   u32 numbufs;      /* number of useful buffers allocated (per device) */
   u32 bufsize      = DT3155_MAX_ROWS * DT3155_MAX_COLS;
-  int m;               /* minor # of device, looped for all devs */
+  int minor;
 
   /* zero the fbuffer status and address structure */
-    for (m = 0; m < ndevices; m++) {
-	dt3155_fbuffer[m] = &(dt3155_status[m].fbuffer);
-
-      /* Make sure the buffering variables are consistent */
-      {
-	u8 *ptr = (u8 *) dt3155_fbuffer[m];
-		for (index = 0; index < sizeof(struct dt3155_fbuffer); index++)
-			*(ptr++) = 0;
-      }
+    for (minor = 0; minor < ndevices; minor++) {
+	fb = &dt3155_status[minor].fbuffer;
+	memset(fb, 0, sizeof(*fb));
     }
 
   /* allocate a large contiguous chunk of RAM */
@@ -362,11 +332,12 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
   /* now that we have board memory we spit it up */
   /* between the boards and the buffers          */
     rambuff_acm = rambuff_addr;
-    for (m = 0; m < ndevices; m++) {
+    for (minor = 0; minor < ndevices; minor++) {
+	fb = &dt3155_status[minor].fbuffer;
 	rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
 
 	/* Save the start of this boards buffer space (for mmap).  */
-	dt3155_status[m].mem_addr = rambuff_acm;
+	dt3155_status[minor].mem_addr = rambuff_acm;
 
 	for (index = 0; index < numbufs; index++) {
 		rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
@@ -377,31 +348,29 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
 			return -ENOMEM;
 		}
 
-		dt3155_fbuffer[m]->frame_info[index].addr = rambuff_acm;
-		push_empty(index, m);
-		/* printk("  - Buffer : %lx\n",
-		* dt3155_fbuffer[m]->frame_info[index].addr);
-		*/
-		dt3155_fbuffer[m]->nbuffers += 1;
+		fb->frame_info[index].addr = rambuff_acm;
+		push_empty(index, minor);
+		/* printk("  - Buffer : %lx\n", fb->frame_info[index].addr); */
+		fb->nbuffers += 1;
 		rambuff_acm += bufsize;
 	}
 
 	/* Make sure there is an active buffer there. */
-	dt3155_fbuffer[m]->active_buf    = pop_empty(m);
-	dt3155_fbuffer[m]->even_happened = 0;
-	dt3155_fbuffer[m]->even_stopped  = 0;
+	fb->active_buf    = pop_empty(minor);
+	fb->even_happened = 0;
+	fb->even_stopped  = 0;
 
 	/* make sure there is no locked_buf JML 2/28/00 */
-	dt3155_fbuffer[m]->locked_buf = -1;
+	fb->locked_buf = -1;
 
-	dt3155_status[m].mem_size =
-	rambuff_acm - dt3155_status[m].mem_addr;
+	dt3155_status[minor].mem_size = rambuff_acm -
+					dt3155_status[minor].mem_addr;
 
 	/* setup the ready queue */
-	dt3155_fbuffer[m]->ready_head = 0;
-	dt3155_fbuffer[m]->ready_len = 0;
+	fb->ready_head = 0;
+	fb->ready_len = 0;
 	printk(KERN_INFO "Available buffers for device %d: %d\n",
-	    m, dt3155_fbuffer[m]->nbuffers);
+	    minor, fb->nbuffers);
     }
 
     return 1;
@@ -412,103 +381,100 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
  *
  * The internal function for releasing a locked buffer.
  * It assumes interrupts are turned off.
- *
- * m is minor number of device
  *****************************************************/
-static void internal_release_locked_buffer(int m)
+static void internal_release_locked_buffer(int minor)
 {
-  /* Pointer into global structure for handling buffers */
-    if (dt3155_fbuffer[m]->locked_buf >= 0) {
-	push_empty(dt3155_fbuffer[m]->locked_buf, m);
-	dt3155_fbuffer[m]->locked_buf = -1;
-    }
-}
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 
+	if (fb->locked_buf >= 0) {
+		push_empty(fb->locked_buf, minor);
+		fb->locked_buf = -1;
+	}
+}
 
 /*****************************************************
- * dt3155_release_locked_buffer()
- * m is minor # of device
+ * dt3155_release_locked_buffer
  *
  * The user function of the above.
- *
  *****************************************************/
-void dt3155_release_locked_buffer(int m)
+void dt3155_release_locked_buffer(int minor)
 {
 	unsigned long int flags;
+
 	local_save_flags(flags);
 	local_irq_disable();
-	internal_release_locked_buffer(m);
+	internal_release_locked_buffer(minor);
 	local_irq_restore(flags);
 }
 
-
 /*****************************************************
- * dt3155_flush()
- * m is minor # of device
- *
+ * dt3155_flush
  *****************************************************/
-int dt3155_flush(int m)
+int dt3155_flush(int minor)
 {
-  int index;
-  unsigned long int flags;
-  local_save_flags(flags);
-  local_irq_disable();
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+	unsigned long int flags;
+	int index;
 
-  internal_release_locked_buffer(m);
-  dt3155_fbuffer[m]->empty_len = 0;
+	local_save_flags(flags);
+	local_irq_disable();
 
-    for (index = 0; index < dt3155_fbuffer[m]->nbuffers; index++)
-	push_empty(index,  m);
+	internal_release_locked_buffer(minor);
+	fb->empty_len = 0;
 
-  /* Make sure there is an active buffer there. */
-  dt3155_fbuffer[m]->active_buf = pop_empty(m);
+	for (index = 0; index < fb->nbuffers; index++)
+		push_empty(index, minor);
 
-  dt3155_fbuffer[m]->even_happened = 0;
-  dt3155_fbuffer[m]->even_stopped  = 0;
+	/* Make sure there is an active buffer there. */
+	fb->active_buf = pop_empty(minor);
 
-  /* setup the ready queue  */
-  dt3155_fbuffer[m]->ready_head = 0;
-  dt3155_fbuffer[m]->ready_len = 0;
+	fb->even_happened = 0;
+	fb->even_stopped  = 0;
 
-  local_irq_restore(flags);
+	/* setup the ready queue  */
+	fb->ready_head = 0;
+	fb->ready_len = 0;
 
-  return 0;
+	local_irq_restore(flags);
+
+	return 0;
 }
 
 /*****************************************************
- * dt3155_get_ready_buffer()
- * m is minor # of device
+ * dt3155_get_ready_buffer
  *
  * get_ready_buffer will grab the next chunk of data
  * if it is already there, otherwise it returns 0.
  * If the user has a buffer locked it will unlock
  * that buffer before returning the new one.
  *****************************************************/
-int dt3155_get_ready_buffer(int m)
+int dt3155_get_ready_buffer(int minor)
 {
-  int frame_index;
-  unsigned long int flags;
-  local_save_flags(flags);
-  local_irq_disable();
+	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+	unsigned long int flags;
+	int frame_index;
+
+	local_save_flags(flags);
+	local_irq_disable();
 
 #ifdef DEBUG_QUES_A
-  printques(m);
+	printques(minor);
 #endif
 
-  internal_release_locked_buffer(m);
+	internal_release_locked_buffer(minor);
 
-    if (is_ready_buf_empty(m))
-	frame_index = -1;
-    else {
-	frame_index = pop_ready(m);
-	dt3155_fbuffer[m]->locked_buf = frame_index;
+	if (is_ready_buf_empty(minor)) {
+		frame_index = -1;
+	} else {
+		frame_index = pop_ready(minor);
+		fb->locked_buf = frame_index;
     }
 
 #ifdef DEBUG_QUES_B
-  printques(m);
+	printques(minor);
 #endif
 
-  local_irq_restore(flags);
+	local_irq_restore(flags);
 
-  return frame_index;
+	return frame_index;
 }
diff --git a/drivers/staging/dt3155/dt3155_isr.h b/drivers/staging/dt3155/dt3155_isr.h
index 7d474cf..c4cf865 100644
--- a/drivers/staging/dt3155/dt3155_isr.h
+++ b/drivers/staging/dt3155/dt3155_isr.h
@@ -36,8 +36,6 @@ MA 02111-1307 USA
 #ifndef DT3155_ISR_H
 #define DT3155_ISR_H
 
-extern struct dt3155_fbuffer *dt3155_fbuffer[MAXBOARDS];
-
 /* User functions for buffering */
 /* Initialize the buffering system.  This should */
 /* be called prior to enabling interrupts */
