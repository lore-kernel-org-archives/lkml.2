Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0IUXEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:04:32 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:40842 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0IUXEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:04:31 -0400
Date: Wed, 22 Sep 2010 00:04:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Huang Ying <ying.huang@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
In-Reply-To: <1284087065-32722-3-git-send-email-ying.huang@intel.com>
Message-ID: <alpine.LFD.2.00.1009212333280.6717@eddie.linux-mips.org>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com> <1284087065-32722-3-git-send-email-ying.huang@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010, Huang Ying wrote:

> memory parity error is only valid for IBM PC-AT, newer machine use 7
> bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
> reported via MCE. So corresponding function name and kernel log string
> is changed.

 Things perhaps changed over the last few years while I have not been 
watching, but for many years the bit #7 of the NMI status port 
(implemented by the southbridge at 0x61 in the port I/O space) was still 
used for memory parity or ECC errors even after the original IBM PC/AT.  
The usual arrangement was in the event of a memory error the memory 
controller in the northbridge would assert the chip's PCI SERR output 
line, which in turn would be trapped by the southbridge and converted to 
an NMI event while setting the said bit in the NMI status port.  See e.g. 
the 82349HX System Controller datasheet (Intel document number 290551).

 So the name of the error reported is not that unjustified except, of 
course, to be precise the handler would have to scan the state of the SERR 
output reported by all the PCI devices in the PCI configuration space to 
find the originator and then interpret the event accordingly.  Which 
obviously means the only piece of code that could exactly know what the 
reason was is the respective device driver as causes of SERR are 
device-specific and may require processing of device-specific registers to 
determine the cause and/or recover (a device reset may be required in some 
cases).

 Of course using the MCE seems natural and better, especially if the 
exception can be raised synchronously and stop the failing memory load CPU 
instruction from completion -- this is important for parity and MBE ECC 
errors, where in some cases the handler may be able to retry the failing 
operation having refreshed RAM from the backing store or otherwise the 
affected process must be killed (unless a kernel memory location is 
involved that is, where the whole system has to be brought down).

 OTOH, for CPU stores and DMA transactions the event will always be 
asynchronous and an NMI might be a better option, as in the case of parity 
and MBE ECC errors the whole system will probably have to be brought down, 
and with SBE ECC errors scrubbing can be done at any time and otherwise 
(except from logging and/or marking the physical page bad, as required) no 
action is needed.

  Maciej
