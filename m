Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0GLXku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:40:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49095 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0GLXkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:40:49 -0400
Message-ID: <4C3BA731.40508@oracle.com>
Date: Mon, 12 Jul 2010 16:37:21 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com> <20100712174420.GC5687@lenovo> <4C3B5A4A.4070107@zytor.com> <4C3B5AC9.3070604@oracle.com> <4C3B9DD4.1040808@goop.org>
In-Reply-To: <4C3B9DD4.1040808@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C3BA7CB.01CD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 03:57 PM, Jeremy Fitzhardinge wrote:
> On 07/12/2010 11:11 AM, Yinghai Lu wrote:
>> On 07/12/2010 11:09 AM, H. Peter Anvin wrote:
>>   
>>> On 07/12/2010 10:44 AM, Cyrill Gorcunov wrote:
>>>     
>>>> Peter, while reviewing this patch I found another nit in
>>>> context of early_param usage, so the patch is below. It's
>>>> completely trivial. Actually I thought I've already fixed
>>>> all early_param cases long ago but this one somehow sneaked ;)
>>>>
>>>> Anyway, Yinghai, Peter,
>>>>
>>>> I'm not sure but can't we use some boot_param "pad" field for
>>>> "being copied" flag instead of new variable? There is a case
>>>> when boot_param is used as __initdata and I'm not sure we clear
>>>> this section explicitly.
>>>>
>>>>       
>>> Actually, even better would be to simply use boot_params.hdr.version,
>>> which will never be zero.
>>>     
>> Jeremy,
>>
>> any reason that xen cat not use x86_64_start_kernel directly?
>>   
> 
> As I remember it, I split x86_64_start_kernel into two pieces, one
> containing the bits that were awkward with Xen.  I don't remember which
> were the problematic parts, but it all looks pretty tricky.  Specifically:
> 
>     * Xen will pre-clear the bss, so that's not necessary
>     * we don't go via head, so cleanup_highmap isn't either
>     * PV domains don't have an IDT available to them, or any of their
>       associated structures
> 
> So the whole thing looks at best reundant, and at worst has the
> potential for causing subtle damage.
> 
> Why do you ask?  Does it relate to the early console stuff, or are you
> just asking because you're looking at it?

yes, make setup_early_console()/copy_bootdata two times....

and that looks strange.

 
+static int __initdata bootdata_copied;
 static void __init copy_bootdata(char *real_mode_data)
 {
        char * command_line;
 
+       if (bootdata_copied)
+               return;
+
        memcpy(&boot_params, real_mode_data, sizeof boot_params);
        if (boot_params.hdr.cmd_line_ptr) {
                command_line = __va(boot_params.hdr.cmd_line_ptr);
                memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
        }
+
+       bootdata_copied = 1;
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
@@ -73,6 +80,10 @@ void __init x86_64_start_kernel(char * real_mode_data)
        /* clear bss before set_intr_gate with early_idt_handler */
        clear_bss();
 
+       /* boot_params is in bss */
+       copy_bootdata(__va(real_mode_data));
+       setup_early_console();
+
        /* Make NULL pointers segfault */
        zap_identity_mappings();
 
@@ -97,8 +108,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
 void __init x86_64_start_reservations(char *real_mode_data)
 {
        copy_bootdata(__va(real_mode_data));
+       setup_early_console();
+

Thanks

Yinghai Lu
