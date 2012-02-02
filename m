Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2BBPFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:05:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:32938 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab2BBPFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:05:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119708101"
Message-ID: <4F2AA642.1030400@linux.intel.com>
Date: Thu, 02 Feb 2012 07:05:38 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: James Bottomley <jbottomley@parallels.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
References: <20120121082857.GC32134@elte.hu>  <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>  <20120121165830.GA9216@elte.hu>  <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>  <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>  <CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>  <CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>  <20120131115855.5861bad7@pyramind.ukuu.org.uk>  <20120131120922.GD32010@elte.hu>  <20120131121820.58a1db97@pyramind.ukuu.org.uk>  <20120131122339.GG32010@elte.hu>  <CA+55aFw4F-02NxbQHmpy0KtXxKc9++HutgVXd7nGe0G7NqG+Gw@mail.gmail.com> <1328144756.2768.57.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1328144756.2768.57.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 05:05 PM, James Bottomley wrote:
>
> Incidentally, the last time this came up was with mpt fusion: for a
> write to a 64 bit register, it didn't care about order, but it did care
> about interleaving as in if you write one half of a 64 bit register and
> then write to another register, the 64 bit register effectively gets
> written with zeros in the part you didn't write to, so we had to put a
> spin lock in the open coded writeb/w/l/q() to make sure the card didn't
> get interleaved writes.
>

There are always going to be hardware which have specific needs, and for 
those open-coding makes sense, but the littleendian/bigendian pair is 
going to cover ~90% of users and make sense to can.

I worked myself on a driver (which sadly never shipped) which had an WC 
window and a UC window... the final write in a series had a completion 
bit in it and would go to the UC window after setting up a whole chunk 
of operations in the WC window (writing UC memory flushes WC memory 
ahead of it.)

Thus, the two-part breakdown of writeq() to the UC window had to write 
the low half to the WC window instead.  This is clearly not generic.

	-hpa


