Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab2JLLCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:02:54 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:51225 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2JLLCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:02:53 -0400
X-Greylist: delayed 3948 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2012 07:02:52 EDT
Message-ID: <5077E96C.4030609@numascale.com>
Date: Fri, 12 Oct 2012 11:57:00 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH v2] Fix AMD Northbridge-ID contiguity assumptions
References: <1349270474-28808-1-git-send-email-daniel@numascale-asia.com> <20121004131801.GD21028@aftab.osrc.amd.com> <20121012093310.GC19420@aftab.osrc.amd.com>
In-Reply-To: <20121012093310.GC19420@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 11:33, Borislav Petkov wrote:
> On Thu, Oct 04, 2012 at 03:18:02PM +0200, Borislav Petkov wrote:
>> On Wed, Oct 03, 2012 at 09:21:14PM +0800, Daniel J Blueman wrote:
>>> The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
>>> are contiguous, which no longer holds on federated systems with multiple
>>> HyperTransport fabrics and multiple PCI domains.
>>>
>>> Address this assumption by searching the Northbridge ID array, rather than
>>> directly indexing it, using the upper bits for the PCI domain.
>>>
>>> v2: Fix Northbridge entry initialisation
>>>
>>> Tested on a single-socket system and 3-server federated system.
>>>
>>> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
>>> ---
>>>   arch/x86/include/asm/amd_nb.h |   23 +++++++++++++++++++++--
>>>   arch/x86/kernel/amd_nb.c      |   16 +++++++++-------
>>>   drivers/edac/amd64_edac.c     |   18 +++++++++---------
>>>   drivers/edac/amd64_edac.h     |    6 ------
>
> Ok,
>
> I've been meaning to clean up that amd_nb.c code which iterates over all
> PCI devices on the system just so it can count the NBs and then do it
> again in order to do the ->misc and ->link assignment.
>
> So below is what I've come up with and it builds but it is completely
> untested and I might be completely off, for all I know.
>
> The basic idea, though, is to have the first 8 NB descriptors in an
> array of 8 and use that for a fast lookup on all those single-board
> machines where the number of the northbridges is the number of physical
> processors on the board (or x2, if a MCM).
>
> Then, there's a linked list of all further NB descriptors which should
> work in your case of confederated systems.
>
> Btw, I've also reused your get_node_id function and the edac changes are
> still pending but they should be trivial once this new approach pans
> out.
>


Hi Boris,

This patch looks very clean and should serve our purpose as well (I'll 
double check with Daniel).

Regarding the size of the "node" variable, you asked before. The 
theoretical maximum number of AMD NBs we can have in a confederated 
NumaConnect system _today_ is 8*4096 (8 NBs per system, 4096 systems) so 
technically this could fit into a u16 instead of a u32 (you'll have to 
shift left by 3 instead of 8).

However, to allow some flexibility I think a u32 is better and I think 
we can live with those two extra bytes per struct member, or ?

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
