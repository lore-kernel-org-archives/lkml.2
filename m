Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0L3Sh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:37:27 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41824 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0L3Sh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:37:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type;
        b=peOh4LrkG4SGpBVOfQS4CfB2f/P0XkkoSPrdGVf95YArJ9I8oG6o9KDlM7K829kqLm
         cT3mjqq1uSsujp22sToE24PvnXIv7DvNyVINSW2U392Y2X38BHbbKlSnWIdt7dUL8asZ
         52hL8rWUEtekqW4ah+xvAnr84X5jgyhGofqRQ=
Message-ID: <4D1CD161.4040107@lwfinger.net>
Date: Thu, 30 Dec 2010 12:37:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
References: <4D1A8200.4010609@lwfinger.net> <20101229195440.GD5838@darkside.kls.lan> <4D1BD2B0.4020101@lwfinger.net> <20101230012003.GA2665@darkside.kls.lan> <4D1BF056.3060909@lwfinger.net> <20101230143406.GA23219@darkside.kls.lan>
In-Reply-To: <20101230143406.GA23219@darkside.kls.lan>
Content-Type: multipart/mixed;
 boundary="------------010805070504040603080303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010805070504040603080303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/30/2010 08:34 AM, Mario 'BitKoenig' Holbe wrote:
> On Wed, Dec 29, 2010 at 08:37:10PM -0600, Larry Finger wrote:
>> No, don't bother. I do have a different request. The byte counts for my 32-bit
>> system do not match yours. Could you please use the following command to find
>> the instructions that are failing?
>>
>> objdump -l -d drivers/char/hw_random/core.o | less
>>
>> Use the search to find the start of hwrng_register, then add 0x4c to the
>> starting address. Once I see hte instruction that is failing, I should be able
>> to find where the failure occurs.
> 
> Alright, here we go...
> 
> [   30.012695] BUG: unable to handle kernel paging request at 4b28f458
> [   30.012708] IP: [<f90703cc>] hwrng_register+0x4c/0x139 [rng_core]
> 
> 00000380 <hwrng_register>:
> hwrng_register():
> /tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:299
>  380:   56                      push   %esi
>  381:   53                      push   %ebx
> ...
> /tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:312
>  3c6:   8b 76 1c                mov    0x1c(%esi),%esi
>  3c9:   83 ee 1c                sub    $0x1c,%esi
> prefetch():
> /tmp/1/linux-source-2.6.37-rc7/arch/x86/include/asm/processor.h:837
>  3cc:   8b 46 1c                mov    0x1c(%esi),%eax
>  3cf:   8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
> hwrng_register():
> /tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:312
>  3d3:   81 fe f8 ff ff ff       cmp    $0xfffffff8,%esi
>  3d9:   75 d4                   jne    3af <hwrng_register+0x2f>
> /tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:319
> 
>    312		list_for_each_entry(tmp, &rng_list, list) {
>    313			if (strcmp(tmp->name, rng->name) == 0)
>    314				goto out_unlock;
>    315		}
> 
> This is btw. the same data that is accessed in the cat rng_available
> crash via hwrng_attr_available_show():
> 
> [  389.303538] BUG: unable to handle kernel paging request at 288dcb5b                              
> [  389.303553] IP: [<f8dda34c>] hwrng_attr_available_show+0x5c/0x90 [rng_core]                      
> 
> 000002f0 <hwrng_attr_available_show>:
> hwrng_attr_available_show():
> /tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:236
>  2f0:   55                      push   %ebp
> ...
> /tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:245
>  346:   8b 5b 1c                mov    0x1c(%ebx),%ebx
>  349:   83 eb 1c                sub    $0x1c,%ebx
> prefetch():
> /tmp/1/linux-source-2.6.37-rc7/arch/x86/include/asm/processor.h:837
>  34c:   8b 43 1c                mov    0x1c(%ebx),%eax
>  34f:   8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
> hwrng_attr_available_show():
> /tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:245
> 
>    245		list_for_each_entry(rng, &rng_list, list) {
>    246			strncat(buf, rng->name, PAGE_SIZE - ret - 1);
>    247			ret += strlen(rng->name);
>    248			strncat(buf, " ", PAGE_SIZE - ret - 1);
>    249			ret++;
>    250		}

The head of the rng_list is damaged. It is initialized at compile time and
should be OK. To help discover the order in which hwrng_register() is called,
apply the attached patch. Run it once with commit 84c164a34ffe67908a installed,
and once with it reverted.

Thanks,

Larry




--------------010805070504040603080303
Content-Type: text/plain;
 name="hwrng_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hwrng_debug"

Index: wireless-testing/drivers/char/hw_random/core.c
===================================================================
--- wireless-testing.orig/drivers/char/hw_random/core.c
+++ wireless-testing/drivers/char/hw_random/core.c
@@ -49,11 +49,11 @@
 
 
 static struct hwrng *current_rng;
-static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 static int data_avail;
 static u8 rng_buffer[SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES]
 	__cacheline_aligned;
+static LIST_HEAD(rng_list);
 
 static inline int hwrng_init(struct hwrng *rng)
 {
@@ -305,6 +305,9 @@ int hwrng_register(struct hwrng *rng)
 	    (rng->data_read == NULL && rng->read == NULL))
 		goto out;
 
+	printk(KERN_INFO "Calling hwrng_register\n");
+	dump_stack();
+
 	mutex_lock(&rng_mutex);
 
 	/* Must not register two RNGs with the same name. */

--------------010805070504040603080303--
