Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0LMX6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:58:25 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58984 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756859Ab0LMX6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:58:22 -0500
Message-ID: <4D06B317.2090608@sgi.com>
Date: Mon, 13 Dec 2010 15:58:15 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Len Brown <lenb@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Early kernel messages are overflowing the static log buffer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

We have a problem on customer sites in that the early log buffer
messages overflow the static 128M log buffer before the log_buffer_len
parameter can be processed.  This causes a major problem when we
are trying to debug a kernel panic from the customer's panic dump.

I've tried processing the log_buffer_len as soon as possible,
(right after the setup of Bootmem on Node 0), but I still lose 
quite a bit.  I think I've calculated that there are about
192M of messages output on a 2048 processor 128 node 4TB system
before the log buffer can be dynamically reallocated.  And this
increases the complexity a bit because this is in arch dependent
code, so a generic reallocation routine is still needed.

And distros are against any attempt to increase the size of the
static log buffer so that's not really an option.

So it seems we need to reduce the number of messages.  

The voluminous message sources before buffer reallocation are:

[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)                                              
...
[    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)                     [    
...
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)                         
...
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
...
[    0.000000] Bootmem setup node 0 0000000000000000-0000000800000000
[    0.000000]   NODE_DATA [000000000000e100 - 00000000000420ff]
[    0.000000]   bootmap [0000000000100000 -  00000000001fffff] pages 100
...
[    0.000000] early_node_map[137] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
...
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 114688 pages used for memmap
[    0.000000]   Normal zone: 8273920 pages, LIFO batch:31
...
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] enabled)
...
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
...
[    0.000000] pcpu-alloc: [000] 0000 0001 0002 0003 0004 0005 0006 0007 1024 1025 1026 1027 1028 1029 1030 1031

What I'm asking is which of these would be most acceptable to
either remove or replace with some sort of message reduction?
Note that a lot of the messages are completely redundant.  Like
the Bootmem setup generally has exactly the same information
(spread over 15 lines), for each of the 128 Nodes.

One patch that I still have was David's "reduce srat verbosity in
the kernel log" that was rejected by you as too complex.  This
would have resulted in about a 16:1 reduction in SRAT: messages,
without loss of an information.  Before I start another doomed patch,
I'd like to find out the guidelines.  Remember, no one really looks
at these messages unless the system panics, usually during startup.
So the information here may be key to diagnosing the problem.

Thanks,
Mike



