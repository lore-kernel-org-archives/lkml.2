Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0DHIdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:33:06 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:41845 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0DHIdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:33:01 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Apr 2010 04:33:01 EDT
Message-ID: <4BBD86A5.5030109@lumino.de>
Date: Thu, 08 Apr 2010 09:32:53 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: atomic RAM ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... continuing a discussion on a similar issue some months ago ...

Hi experts,
To do Futex in userspace and many things in the Kernel there are several
predefined "atomic" macros.

Depending on the arch, there are several ways to do this:

 - normal "read-modify-write" processor instructions that by design are
not interrupted  (e.g. x86 and 68K non-SMP)
 - normal "read-modify-write" processor instructions that by design are
not interrupted and bus locking (e.g. Ubicom 7K SMP)
 - normal "read-modify-write" processor instructions with bus lock
prefix instruction (x86 SMP)
 - disable, enable the Interrupt (non-SMP archs that allow for this,
often used in user space with uClinux)
 - "atomic region": the global ISR (return) code detects and finalizes
atomic functions, because they are in a certain code region (non-SMP
archs that don't have atomic instructions, e.g. BlackFin)

Now I (we ?) face a new class of archs. Here I use the (currently
non-SMP), MMU-enabled NIOS2 (provided as IP-Core in Altera FPGA). I
suppose there are other IP-Core processors or otherwise expendable CPUs
with similar specs:

 - no normal processor "read-modify-write" instructions that by design
are not interrupted or even bus-locking
 - new "custom" processor instructions can be defined that might work
atomically, as well not interruptible as kind of bus-locking for SMP use
 - these custom instructions can't access the memory in normal way
(through the MMU and the cache).

So to implement atomic instructions a dedicated RAM area would be needed
to hold the atomically accessible data. Same can't be accessed by the
CPU in other ways. This RAM area would be implemented with the new
atomic instructions and be located within the FPGA and thus could
accessed very fast (no cache issues).

Of course this would need for the Kernel and the libraries to avoid any
access to that RAM area with normal instructions. All code would need to
use the set of "atomic" macros to access that RAM. Here I suppose we
would need some additional atomic Macros such as "atomic_malloc()",
"atomic_read_word()" etc, which, with normal archs would just reproduce
the standard code.

Of course the size of the "atomic RAM" would be limited and thus a
system error would be generated if same would be exhausted. I don't
think that, with the intended "embedded" use, this would be a serious issue.

I feel that thinking about this could be viable task - even if this
might ask for some modifications in the global arch-independent Kernel
and/or library code, as I suppose this is the only way to allow for
implementing an SMP design with NIOS and similar archs. (Happily these
modifications would be "compatible" by design as with any existing arch
just the existing code would be reproduced by the new Macros and so
their use is strictly optional with any arch other than those that would
profit from the new implementation.)

What do you think ?

-Michael

