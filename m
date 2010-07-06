Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0GFOad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 10:30:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43628 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab0GFOab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 10:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=T4s1w/U5AW/382JHZdMx4lAzE2TDtT3wDalrWRZmeMkSEe6sTgUQbnD+aZnQ6MxOl8
         gOZemwlCwHfSIQtJ+kvi0YT8g36BkCoRtTtbiizUXb/6iYM1L4DFjeuGSPK/ibDwVZVI
         99++GA/5LjdW2U3Nr2AnQwyGnjRGrlNM211FA=
Message-ID: <4C333E1D.8020805@gmail.com>
Date: Tue, 06 Jul 2010 07:30:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: akpm@linux-foundation.org, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]ipmi:ipmi_si_intf.c Fix warning: variable 'addr_space'
 set but not used
References: <1278390662-9455-1-git-send-email-justinmattock@gmail.com> <4C333636.1040904@acm.org>
In-Reply-To: <4C333636.1040904@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 06:57 AM, Corey Minyard wrote:
> Well, this patch is incorrect because IPMI_IO_ADDR_SPACE is zero.  I'm
> not sure what your change is trying to accomplish, anyway. This is
> actually dead code from a previous change, I believe, and just needs to
> be removed. I did find that document at
> http://h21007.www2.hp.com/portal/download/files/unprot/hpspmi.pdf, not
> sure if there's a more reliable place to find it.
>
> -corey
>

cool thanks.. so it's dead code..I'll resend then with it removed.
as for the web address I don't know how you found that.. i.e. I spent at 
least 45mins looking on that site for that *.pdf(searching gives nothing 
etc..)

> On 07/05/2010 11:31 PM, Justin P. Mattock wrote:
>> Remove addr_space in exchange for two symbols that represent
>> mm = IPMI_MEM_ADDR_SPACE;
>> io = IPMI_IO_ADDR_SPACE;
>> then add a dev_warn printing information so that GCC doesn't give a
>> warning when building the kernel.
>> the original warning from GCC is this:
>>
>> CC [M] drivers/char/ipmi/ipmi_si_intf.o
>> drivers/char/ipmi/ipmi_si_intf.c: In function 'try_init_spmi':
>> drivers/char/ipmi/ipmi_si_intf.c:2016:8: warning: variable
>> 'addr_space' set but not used
>>
>> And also the web address pointing to a *.pdf is no where to be
>> found(or atleast I couldn't
>> find it), so just use the web site itself(if somebody has the *.pdf
>> let me know I can change this).
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>> drivers/char/ipmi/ipmi_si_intf.c | 14 +++++++++-----
>> 1 files changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
>> b/drivers/char/ipmi/ipmi_si_intf.c
>> index 094bdc3..969e69a 100644
>> --- a/drivers/char/ipmi/ipmi_si_intf.c
>> +++ b/drivers/char/ipmi/ipmi_si_intf.c
>> @@ -1965,8 +1965,7 @@ static int acpi_gpe_irq_setup(struct smi_info
>> *info)
>>
>> /*
>> * Defined at
>> - * http://h21007.www2.hp.com/dspp/files/unprotected/devresource/
>> - * Docs/TechPapers/IA64/hpspmi.pdf
>> + * http://h21007.www2.hp.com/portal/site/dspp
>> */
>> struct SPMITable {
>> s8 Signature[4];
>> @@ -2013,7 +2012,7 @@ struct SPMITable {
>> static __devinit int try_init_spmi(struct SPMITable *spmi)
>> {
>> struct smi_info *info;
>> - u8 addr_space;
>> + u8 mem, io;
>>
>> if (spmi->IPMIlegacy != 1) {
>> printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
>> @@ -2021,9 +2020,14 @@ static __devinit int try_init_spmi(struct
>> SPMITable *spmi)
>> }
>>
>> if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
>> - addr_space = IPMI_MEM_ADDR_SPACE;
>> + mem = IPMI_MEM_ADDR_SPACE;
>> else
>> - addr_space = IPMI_IO_ADDR_SPACE;
>> + io = IPMI_IO_ADDR_SPACE;
>> +
>> + if (mem || io) {
>> + dev_warn(info->dev, "spmi address space %d\n", mem ?: io);
>> + return 0;
>> + }
>>
>> info = kzalloc(sizeof(*info), GFP_KERNEL);
>> if (!info) {
>
>

Justin P. Mattock
