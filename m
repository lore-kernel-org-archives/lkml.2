Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1C2MZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:25:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42284 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1C2MZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:25:03 -0400
Message-ID: <4D91CF9D.3050500@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 08:25:01 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeff Layton <jlayton@poochiereds.net>
CC: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: TPM chip prevents machine from suspending
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net> <4D91157F.2020502@linux.vnet.ibm.com> <20110329080856.1726dfaa@tlielax.poochiereds.net>
In-Reply-To: <20110329080856.1726dfaa@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 08:08 AM, Jeff Layton wrote:
> On Mon, 28 Mar 2011 19:10:55 -0400
> Stefan Berger<stefanb@linux.vnet.ibm.com>  wrote:
>
>> Ok, so this error code means TPM_INVALID_POSTINIT  (not a posix code)
>> and means that this command was received in the wrong sequence relative
>> to a TPM_Startup command. Well, what's supposed to be happening is this:
>>
>> When the machines (S3) suspends then the OS needs to send a
>> TPM_SaveState() to the TPM. This is done by the Linux driver. Once the
>> VM resumes, the BIOS is supposed to send a TPM_Startup(ST_STATE) to the TPM.
>>
>> Now the fun starts when a BIOS isn't doing that (even though the spec
>> says it's supposed to), which could very well be the case in your case
>> (don't know what broken BIOSes are out there...  Did it ever work before
>> with the TPM driver in the kernel ?). I could try to send you a small
>> tool that you would have to run from user space upon resume so that we
>> can see that this error goes away. If that's verified we could
>> subsequently write a patch for the TPM driver to also send the
>> TPM_Startup(ST_STATE) to the TPM, which then in the case of most BIOSes
>> would be the 2nd time that the TPM receives such a command. I think TPMs
>> should be able to digest this 2nd TPM_Startup() well, but I'd have to
>> check -- but really we would ill-fix it just because of one (possibly)
>> buggy BIOS.
>>
>> The failure of the 2nd suspend then likely stems from the TPM not
>> accepting the TPM_SaveState() anymore since it hasn't seen the
>> TPM_Startup(ST_STATE) that we expected the BIOS to send.
>>
> Yep. That program fixed the problem. When I run it after a resume, I
> can then cat the caps file and get output from it, and the machine will
> successfully suspend again.
Well, we now could (once) probe the TPM after the resume and send a test 
command to it and see whether it returns error code 38 and if so send 
the TPM_Startup() from the driver -- as a work-around for your broken BIOS.

>> Another possibility would be for you to check for BIOS updates from the
>> laptop manufacturer...
>>
> This is actually a desktop machine and the BIOS for the motherboard is
> at the latest version, though it is quite old -- 2007/09/01. For the
> record this is a:
>
>       Foxconn 6150BK8MC
>
> I'm actually not using the TPM in this thing at all. I'd be just as
> happy if there were some way to disable it. Unfortunately, the option
> in the BIOS to do this doesn't seem to actually work. When I set "TPM
> Control" in the BIOS to "Disable" it always ends up reset back to "No
> Change". I'd report both problems to the mfr, but this thing is long
> out of warranty and I'm pretty sure they won't care.
>
> Is there some way short of recompiling with CONFIG_TCG_* turned off
> to disable the TPM driver at boot time?
>
As far as I know, 'no'. I'd defer it to the maintainers as to how they 
would want to solve your particular problem... either by using above 
work-around, which would be more transparent, or actively having to turn 
the driver off with a command line parameter.

    Stefan

