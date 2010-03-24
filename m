Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0CXRCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:02:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:21901 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0CXRCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uBB/aZ7udKfzfAd3x4Scn5JFI33Ew0VNIFoxj28HPy7qucEzQru4sd9FrcB8SjBR1q
         339rTRSs80u2bWJQ5y6XELjkqcXnxfYPCErEy4aQSgVu3d8JBkk3F/Ko30YSoXng7PR0
         3ydP/wvYsVu07vwUemSnUTXEyDB5u+eBEpW0I=
Message-ID: <4BAA4595.3050203@gmail.com>
Date: Wed, 24 Mar 2010 18:02:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.9 Thunderbird/3.1b1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [git pull] pull request for writable limits for 2.6.34-rc0
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com> <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org> <20100321060607.GA4062@x200> <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 03/21/2010 07:38 PM, Linus Torvalds wrote:
> Yeah, the infinity setting should be cleaned up. I also wonder if we 
> should clean up the odd file limit rules, and make them all be about 
> bytes. Correct me if I'm wrong, but don't we do that whole file size thing 
> in kilobytes right now?

Nope, it's just ulimit in bash who takes "blocks" and calls setrlimit
with 1024*value for core and file size limits.

> I do also agree that maybe we could/should skip the whole "writable /proc" 
> thing.

I agree too, why I had to implement is that we cannot assign syscall
numbers before merging upstream (for obvious reasons of not destroying
userspace interface where programs won't work on our distro) and we
needed the writable-limits feature.

> Or even just _one_ system call that takes two pointers, and can do an 
> atomic replace-and-return-the-old-value, like 'sigaction()' does, ie 
> something like
> 
> 	int prlimit64(pid, limit, const struct rlimit64 *new, struct rlimit64 *old);
> 
> wouldn't that be a nice generic interface?

Seconded. But should the limits be by default 64-bit even on 32-bit? I
mean: switch 'struct limit' in signal_struct to 'struct rlimit64'? This
would make the limits non-atomic on 32-bit. Oh, they are not already if
reader wants both cur and max without any locks, but I'm not sure now
what implications this will have (I haven't checked compilers, but I
think a store of 00000001 0000000 in place of 00000000 ffffffff may
result in a read of 00000001 ffffffff or alike). Or did I misunderstand you?

thanks,
-- 
js
