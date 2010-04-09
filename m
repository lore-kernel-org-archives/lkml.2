Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab0DIBhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 21:37:18 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:37055 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab0DIBhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 21:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eCI3U9LC8wqJgcc0/PkmAD862fJArp9TyvVMHhRxMX7lCHBIXlRXpY5HAp0jvPRvPo
         Wi4f1Q32A3LaEsPsPgdZi02E3lGdGFK7B52zC10ow69pQXT4V4lETR/OoaxaHaAUFuqU
         SKkUtE8N/ECIyw9UiwF8vRLhpriUp+niZa3IQ=
MIME-Version: 1.0
In-Reply-To: <4BBD86A5.5030109@lumino.de>
References: <4BBD86A5.5030109@lumino.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 8 Apr 2010 21:36:54 -0400
Message-ID: <v2u8bd0f97a1004081836na92954bdu4ed473816dc831b9@mail.gmail.com>
Subject: Re: atomic RAM ?
To: Michael Schnell <mschnell@lumino.de>
Cc: linux-kernel@vger.kernel.org, nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 03:32, Michael Schnell wrote:
>  - new "custom" processor instructions can be defined that might work
> atomically, as well not interruptible as kind of bus-locking for SMP use
>  - these custom instructions can't access the memory in normal way
> (through the MMU and the cache).
>
> So to implement atomic instructions a dedicated RAM area would be needed
> to hold the atomically accessible data. Same can't be accessed by the
> CPU in other ways. This RAM area would be implemented with the new
> atomic instructions and be located within the FPGA and thus could
> accessed very fast (no cache issues).
>
> Of course this would need for the Kernel and the libraries to avoid any
> access to that RAM area with normal instructions. All code would need to
> use the set of "atomic" macros to access that RAM. Here I suppose we
> would need some additional atomic Macros such as "atomic_malloc()",
> "atomic_read_word()" etc, which, with normal archs would just reproduce
> the standard code.
>
> Of course the size of the "atomic RAM" would be limited and thus a
> system error would be generated if same would be exhausted. I don't
> think that, with the intended "embedded" use, this would be a serious issue.
>
> I feel that thinking about this could be viable task - even if this
> might ask for some modifications in the global arch-independent Kernel
> and/or library code, as I suppose this is the only way to allow for
> implementing an SMP design with NIOS and similar archs. (Happily these
> modifications would be "compatible" by design as with any existing arch
> just the existing code would be reproduced by the new Macros and so
> their use is strictly optional with any arch other than those that would
> profit from the new implementation.)

the Blackfin already has such an instruction (TESTSET), but since it
has restrictions (cannot be used safely on cached memory), we found it
unusable as a generic solution.  this is why we went to the userspace
fixed atomic code region.

the only time we use this instruction is with the Blackfin SMP port,
and only as an inter-core lock (so it has a fixed address and there is
only one such lock).

i think you underestimate the task of customizing every userspace
point that may want atomic instructions.  and no matter what sized
atomic region you pick, having it arbitrarily fail at runtime because
applications have "too many" locks is a poor solution.
-mike
