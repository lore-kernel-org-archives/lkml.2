Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2KUAU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:20:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2KUAU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:20:57 -0500
MIME-Version: 1.0
In-Reply-To: <50ABF23A.7020305@zytor.com>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
	<1353222571-31544-4-git-send-email-yinghai@kernel.org>
	<50AAB5E8.5070807@zytor.com>
	<CAE9FiQV=G=5zAqv7EiUnb=O7znxuieiCawfgomv9aPNwVAV4uQ@mail.gmail.com>
	<50AABD15.1050809@zytor.com>
	<CAE9FiQVMsBS-c+H7+q3hi5hdvcZ8_AYqm5RV_dOVbV9L1UnxTA@mail.gmail.com>
	<41603b4d-cd34-4c6e-9e1f-ac78816b5097@email.android.com>
	<CAE9FiQVAxkS6AH6zDJAjuyiJtR2xztRG+raCk4L6yvKuskzBkg@mail.gmail.com>
	<CAE9FiQVrjRvQYNDdJFcyDFrr88B6v-86Zdq5a15kdHN_byDG3g@mail.gmail.com>
	<23b6f8fe-37cd-4cbb-9c90-511dab4e5b5b@email.android.com>
	<CAE9FiQUjZG_UakYdpxEf8_EHQ4UBo6GK1E_g4wDY576MFcVL4Q@mail.gmail.com>
	<50ABF23A.7020305@zytor.com>
Date: Tue, 20 Nov 2012 16:20:55 -0800
X-Google-Sender-Auth: -66STdv7GvXVb4v6Xdloen6i1oo
Message-ID: <CAE9FiQUBz-QLAaeyOd7E_Gzpq3m0jZOPp4+hTfdo5PaDZHRerQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] x86: Add macro for 64bit entry startup_64
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/20/2012 12:55 PM, Yinghai Lu wrote:
>>
>> On Tue, Nov 20, 2012 at 12:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> I don't see any point in three flags here.  Let's stick to one flag; then
>>> it fits in the existing boot_flags field.
>>
>>
>> the magic AA55
>>
>> boot/header.S:boot_flag:        .word 0xAA55
>>
>> if change that to other value, would it break existing boot loader?
>> aka old boot loader could boot the new bzImage anymore.
>>
>
> Sorry, I meant loadflags.
>
> This is a read flag and so should be low, bit 1 presumably.

yes.

Field name:     loadflags
Type:           modify (obligatory)
Offset/size:    0x211/1
Protocol:       2.00+

  This field is a bitmask.

  Bit 0 (read): LOADED_HIGH
        - If 0, the protected-mode code is loaded at 0x10000.
        - If 1, the protected-mode code is loaded at 0x100000.

  Bit 5 (write): QUIET_FLAG
        - If 0, print early messages.
        - If 1, suppress early messages.
                This requests to the kernel (decompressor and early
                kernel) to not write early messages that require
                accessing the display hardware directly.

  Bit 6 (write): KEEP_SEGMENTS
        Protocol: 2.07+
        - If 0, reload the segment registers in the 32bit entry point.
        - If 1, do not reload the segment registers in the 32bit entry point.
                Assume that %cs %ds %ss %es are all set to flat segments with
                a base of 0 (or the equivalent for their environment).

  Bit 7 (write): CAN_USE_HEAP
        Set this bit to 1 to indicate that the value entered in the
        heap_end_ptr is valid.  If this field is clear, some setup code
        functionality will be disabled.


So will have
  Bit 1 (read): LOADED_ABOVE_4G
  - If 1, code, boot_param, cmdline, ramdisk could be loaded above 4G,

will update the patches accordingly.

>
> On the other hand, the read flags in loadflags has not been modified for a
> very long time, and there is a serious risk that some broken bootloader
> might be doing a full byte comparison.
>
> relocatable_kernel really should have been a flag, but it is now defined as
> a comparison with zero.  As such, and in an effort to minimize the growth of
> struct setup_header (it is limited to little over 128 bytes long) I suggest
> we redefine the 16-byte field at offset 0x236 as a new flags field.  We
> still only need one flag, though.
>
> Backwards compatibility is so much fun.

yes. try to make it ready for future is fun too.

are you going to have pointer for ext_header ?
