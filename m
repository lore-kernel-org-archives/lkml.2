Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2E3XYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 19:24:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:60047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2E3XYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 19:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158903361"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Topic: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Index: AQHNOZYGtI1DcNZxtEGCK0mbRpqc+pbZOc0AgABYoYCAAAkdAIAAFPOAgAd2gYCAACJ1AIAADiKAgAAIj4CAAZ5vgA==
Date: Wed, 30 May 2012 23:24:41 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com>
 <1337854460-25191-1-git-send-email-mchehab@redhat.com>
 <20120524105604.GC27063@aftab.osrc.amd.com> <4FBE5E1D.7070804@redhat.com>
 <20120524164554.GM27063@aftab.osrc.amd.com> <4FBE7755.2080301@redhat.com>
 <20120529115851.GB29157@aftab.osrc.amd.com> <4FC4D6E2.9060501@redhat.com>
 <20120529145245.GG29157@aftab.osrc.amd.com> <4FC4E9EB.5030801@redhat.com>
In-Reply-To: <4FC4E9EB.5030801@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4UNOrGR003269

>         u32 grain;              /* granularity of reported error in bytes */
> 				   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>> 			dimm->grain = nr_pages << PAGE_SHIFT;

I'm not at all sure what we'll see digging into the chipset registers
like EDAC does - but we do have different granularity when reporting
via machine check banks.  That's why we have this code:

                /*
                 * Mask the reported address by the reported granularity.
                 */
                if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
                        u8 shift = MCI_MISC_ADDR_LSB(m->misc);
                        m->addr >>= shift;
                        m->addr <<= shift;
                }

in mce_read_aux().  In practice right now I think that many errors will
report with cache line granularity, while a few (IIRC patrol scrub) will
report with page (4K) granularity. Linux doesn't really care - they all
have to get rounded up to page size because we can't take away just one
cache line from a process.

> @Tony: Can you ensure us that, on Intel memory controllers, the address
> mask remains constant at module's lifetime, or are there any events that
> may change it (memory hot-plug, mirror mode changes, interleaving 
> reconfiguration, ...)?

I could see different controllers (or even different channels) having
different setup if you have a system with different size/speed/#ranks
DIMMs ... most systems today allow almost arbitrary mix & match, and the
BIOS will decide which interleave modes are possible based on what it
finds in the slots.  Mirroring imposes more constraints, so you will
see less crazy options. Hot plug for Linux reduces to just the hot add
case (as we still don't have a good way to remove DIMM sized chunks of
memory) ... so I don't see any clever reconfiguration possibilities
there (when you add memory, all the existing memory had better stay
where it is, preserving contents). Perhaps the only option where things
might change radically is socket migration ... where the constraint is
only that the target of the migration have >= memory of the source. So
you might move from some weird configuration with mixed DIMM sizes and
thus no interleave, to a homogeneous socket with matched DIMMs and full
interleave. But from an EDAC level, this is a new controller on a new
socket ... not a changed configuration on an existing socket.

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
