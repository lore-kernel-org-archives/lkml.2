Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1DNH5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:57:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39927 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1DNH5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:57:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E0xObqG1zMska5ohe9DDQTZUedldrqkkIjT5KMd+cQLSrbJyFk03ARvxp2ThPRjuPJ
         BHfvBNNhB1yoPoupIyXEhoMPobYtf8YUQ7FmvUhhzBEg/W2N36DjU3VVrvCIyns/HpEp
         fvMRBg2zSGOf5fR83rQy3TW3l3tERYZdfTl4M=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Sk02k6f3gzTn+DJWX3HZKniWS6A@mail.gmail.com>
References: <1302762968-24380-1-git-send-email-youquan.song@intel.com>
	<1302762968-24380-2-git-send-email-youquan.song@intel.com>
	<BANLkTi=Sk02k6f3gzTn+DJWX3HZKniWS6A@mail.gmail.com>
Date: Thu, 14 Apr 2011 11:57:39 +0400
Message-ID: <BANLkTikSEJrWH09B7aiYUSaKhONyL25z4Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] apic: Add print error interrupt reason
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Youquan Song <youquan.song@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "yong.y.wang@linux.intel.com" <yong.y.wang@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "jbaron@redhat.com" <jbaron@redhat.com>,
        "trenn@suse.de" <trenn@suse.de>,
        "kent.liu@intel.com" <kent.liu@intel.com>,
        "chaohong.guo@intel.com" <chaohong.guo@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 heh, drop my prev mail. Patch is good! thanks ans sorry for noise.

On Thursday, April 14, 2011, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Apr 14, 2011 at 10:36 AM, Youquan Song <youquan.song@intel.com> wrote:
>> End user worry about the error interrupt information and intend to know what
>> kind of error interrupts are generated, so this patch add printing out the
>> detail debug information of error interrupt.
>> dynamic debug is not initiated when LAPIC initiation, so the pr_debug will not
>> output the error interrupt debug information when boot.
>> In this patch, we use apic_printk(APIC_DEBUG,), so if add kernel option
>> apic=debug will output the error interrupt during boot.
>>
>> Signed-off-by: Youquan Song <youquan.song@intel.com>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  arch/x86/kernel/apic/apic.c |   38 +++++++++++++++++++++++++-------------
>>  1 files changed, 25 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index fabf01e..3ddf4ef 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -1813,6 +1813,17 @@ void smp_spurious_interrupt(struct pt_regs *regs)
>>  void smp_error_interrupt(struct pt_regs *regs)
>>  {
>>        u32 v, v1;
>> +       u32 i = 0;
>> +       static const char * const error_interrupt_reason[] = {
>> +               "Send CS error",                /* APIC Error Bit 0 */
>> +               "Receive CS error",             /* APIC Error Bit 1 */
>> +               "Send accept error",            /* APIC Error Bit 2 */
>> +               "Receive accept error",         /* APIC Error Bit 3 */
>> +               "Redirectable IPI",             /* APIC Error Bit 4 */
>> +               "Send illegal vector",          /* APIC Error Bit 5 */
>> +               "Received illegal vector",      /* APIC Error Bit 6 */
>> +               "Illegal register address",     /* APIC Error Bit 7 */
>> +       };
>>
> ...
>> -       pr_debug("APIC error on CPU%d: %02x(%02x)\n",
>> -               smp_processor_id(), v , v1);
>> +       apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
>> +                   smp_processor_id(), v , v1);
>> +
>> +       v1 = v1 & 0xff;
>> +       while (v1) {
>> +               if (v1 & 0x1)
>> +                       apic_printk(APIC_DEBUG, KERN_CONT " : %s",
>> +                                   error_interrupt_reason[i]);
>> +               i++;
>> +               v1 >>= 1;
>> +       };
>> +
>
> Hi looks good but please add some array-checking in case if we get
> some damaged result
> from hardware, ie check for i not being out of error_interrupt_reason. Thanks!
>
