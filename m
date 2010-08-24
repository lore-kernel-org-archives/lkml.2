Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0HXMwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:52:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0HXMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:52:35 -0400
Message-ID: <4C73C094.1000101@infradead.org>
Date: Tue, 24 Aug 2010 09:52:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100803 Red Hat/3.1.2-1.el6 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: Jiri Slaby <jirislaby@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Roel Kluin <roel.kluin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: siano: free spinlock before schedule()
References: <1280256161-7971-1-git-send-email-segooon@gmail.com> <4C4F5CA7.1030706@gmail.com> <20100808161022.GB5594@linux-m68k.org>
In-Reply-To: <20100808161022.GB5594@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-08-2010 13:10, Richard Zidlicky escreveu:
> On Wed, Jul 28, 2010 at 12:24:39AM +0200, Jiri Slaby wrote:
> 
> sorry for seeing this so late, was flooded with email lately.
> 
>> There is a better fix (which fixes the potential NULL dereference):
>> http://lkml.org/lkml/2010/6/7/175
> 
>> Richard, could you address the comments there and resend?
> 
> I am running this patch since many weeks (after fixing the compile error obviously). 
> Did not implement your beautification suggestion yet, was doing all kinds of experiments
> with IR and had plenty of unrelated issues.

This patch seems a way better than the previous patch. I've rebased it against
the current tree (and fixed the identation).

The only missing issue on it is the lack of your Signed-off-by. Richard, could you
please send it to us?

---
 drivers/media/dvb/siano/smscoreapi.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- patchwork.orig/drivers/media/dvb/siano/smscoreapi.c
+++ patchwork/drivers/media/dvb/siano/smscoreapi.c
@@ -1098,31 +1098,26 @@ EXPORT_SYMBOL_GPL(smscore_onresponse);
  *
  * @return pointer to descriptor on success, NULL on error.
  */
-struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
+
+struct smscore_buffer_t *get_entry(struct smscore_device_t *coredev)
 {
 	struct smscore_buffer_t *cb = NULL;
 	unsigned long flags;
 
-	DEFINE_WAIT(wait);
-
 	spin_lock_irqsave(&coredev->bufferslock, flags);
+	if (!list_empty(&coredev->buffers)) {
+		cb = (struct smscore_buffer_t *) coredev->buffers.next;
+		list_del(&cb->entry);
+	}
+	spin_unlock_irqrestore(&coredev->bufferslock, flags);
+	return cb;
+}
 
-	/* This function must return a valid buffer, since the buffer list is
-	 * finite, we check that there is an available buffer, if not, we wait
-	 * until such buffer become available.
-	 */
-
-	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
-
-	if (list_empty(&coredev->buffers))
-		schedule();
-
-	finish_wait(&coredev->buffer_mng_waitq, &wait);
-
-	cb = (struct smscore_buffer_t *) coredev->buffers.next;
-	list_del(&cb->entry);
+struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
+{
+	struct smscore_buffer_t *cb = NULL;
 
-	spin_unlock_irqrestore(&coredev->bufferslock, flags);
+	wait_event(coredev->buffer_mng_waitq, (cb = get_entry(coredev)));
 
 	return cb;
 }
