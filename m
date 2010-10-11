Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0JKWVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:21:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:60799 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab0JKWVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,316,1283756400"; 
   d="scan'208";a="846107811"
Message-ID: <4CB38DDB.9050006@linux.intel.com>
Date: Mon, 11 Oct 2010 15:21:15 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, rja@sgi.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:x86/urgent] x86, numa: For each node, register the memory
 blocks actually used
References: <4CB27BDF.5000800@kernel.org> <tip-e9aeb8fdb6b197b9b1e1c49717de892593bb811e@git.kernel.org> <alpine.DEB.2.00.1010111504450.5358@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010111504450.5358@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 03:05 PM, David Rientjes wrote:
>>
>> Use nodememblk_range[] instead of nodes[] in order to make sure we
>> capture the actual memory blocks registered with each node.  nodes[]
>> contains an extended range which spans all memory regions associated
>> with a node, but that does not mean that all the memory in between are
>> included.
>>
>> Reported-by: Russ Anderson <rja@sgi.com>
>> Tested-by: Russ Anderson <rja@sgi.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> LKML-Reference: <4CB27BDF.5000800@kernel.org>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: <stable@kernel.org> 2.6.33 .34 .35 .36
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Sorry I hadn't seen this thread earlier, I wasn't cc'd on it.

Thanks for confirming.  I don't have access to any systems on which I
can verify this condition myself, but I spent some fairly serious time
time morning on code inspection, and I'm pretty sure I grok what this
patch does and that it is the right thing.

This is not just an SGI UV problem but will in fact bite any system
which has nodes with interlaced memory blocks (for example block 0
belongs to node 0, block 1 belongs to node 1, and then block 2 belongs
to node 0 again.)

There are multiple loops after these which rely on the nodes[] range,
but in fact they rely on exactly this loop to have registered the
relevant memory ranges for the node, so fixing this loop fixes the
subsequent ones.  Of course, it *seriously* begs the question why
nodes[] carry a range at all (well, other than to support bootmem, which
seems like yet another good reason to finish off bootmem.)

Any help in testing would be highly appreciated.  Please feel free to
involve anyone else who would likely have access to the kind of large
NUMA x86 systems which are likely to be affected.

	-hpa
