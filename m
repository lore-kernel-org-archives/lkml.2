Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1ATJFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:05:55 -0500
Received: from mail.sysgo.com ([195.145.229.155]:45657 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1ATJFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:05:53 -0500
Message-ID: <4D37FAEF.8080504@sysgo.com>
Date: Thu, 20 Jan 2011 10:05:51 +0100
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serio: allow registered drivers to get status flag
References: <4D358E31.4080700@sysgo.com> <20110118195710.GA27152@core.coreip.homeip.net>
In-Reply-To: <20110118195710.GA27152@core.coreip.homeip.net>
Content-Type: multipart/mixed;
 boundary="------------030903060408030906070601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030903060408030906070601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Am 18.01.2011 20:57, schrieb Dmitry Torokhov:
> On Tue, Jan 18, 2011 at 01:57:21PM +0100, David Engraf wrote:
>> Parse the status byte information to the registered serio drivers as
>> well as the character bytes.
>>
>> Signed-off-by: David Engraf<david.engraf@sysgo.com>
>>
>
>> --- linux-2.6.37/drivers/input/serio/serport.c.orig	2011-01-18 12:33:41.421709232 +0100
>> +++ linux-2.6.37/drivers/input/serio/serport.c	2011-01-18 13:33:24.521711214 +0100
>> @@ -116,8 +116,8 @@ static void serport_ldisc_close(struct t
>>
>>   /*
>>    * serport_ldisc_receive() is called by the low level tty driver when characters
>> - * are ready for us. We forward the characters, one by one to the 'interrupt'
>> - * routine.
>> + * are ready for us. We forward the characters and flags, one by one to the
>> + * 'interrupt' routine.
>>    */
>>
>>   static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *cp, char *fp, int count)
>> @@ -132,7 +132,7 @@ static void serport_ldisc_receive(struct
>>   		goto out;
>>
>>   	for (i = 0; i<  count; i++)
>> -		serio_interrupt(serport->serio, cp[i], 0);
>> +		serio_interrupt(serport->serio, cp[i], fp[i]);
>>
>
> Hi David,
>
> The flags argument that serio_interrupt() accepts not the raw protocol
> data, but sanitized, protocol-independent SERIO_TIMEOUT, SERIO_PARITY
> and SERIO_FRAME bits.
>
> Thanks.
>

Hi Dmitry,

I've updated the patch so that the raw protocol is converted to the 
SERIO_ bits. The raw protocol can parse only one flag, so I don't need 
to store multiple SERIO_ bits in the character flag variable.

Thanks
- David


Signed-off-by: David Engraf<david.engraf@sysgo.com>


--------------030903060408030906070601
Content-Type: text/x-diff;
 name="serport_parse_flags.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="serport_parse_flags.diff"

--- linux-2.6.37/drivers/input/serio/serport.c.orig	2011-01-18 12:33:41.421709232 +0100
+++ linux-2.6.37/drivers/input/serio/serport.c	2011-01-20 09:55:53.849550065 +0100
@@ -116,14 +116,15 @@ static void serport_ldisc_close(struct t
 
 /*
  * serport_ldisc_receive() is called by the low level tty driver when characters
- * are ready for us. We forward the characters, one by one to the 'interrupt'
- * routine.
+ * are ready for us. We forward the characters and flags, one by one to the 
+ * 'interrupt' routine.
  */
 
 static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *cp, char *fp, int count)
 {
 	struct serport *serport = (struct serport*) tty->disc_data;
 	unsigned long flags;
+	unsigned int ch_flags;
 	int i;
 
 	spin_lock_irqsave(&serport->lock, flags);
@@ -131,8 +132,15 @@ static void serport_ldisc_receive(struct
 	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
 		goto out;
 
-	for (i = 0; i < count; i++)
-		serio_interrupt(serport->serio, cp[i], 0);
+	for (i = 0; i < count; i++) {
+		ch_flags = 0;
+		if (fp[i] == TTY_FRAME)
+			ch_flags = SERIO_FRAME;
+		else if (fp[i] == TTY_PARITY)
+			ch_flags = SERIO_PARITY;
+
+		serio_interrupt(serport->serio, cp[i], ch_flags);
+	}
 
 out:
 	spin_unlock_irqrestore(&serport->lock, flags);

--------------030903060408030906070601--
