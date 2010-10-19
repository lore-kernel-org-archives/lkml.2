Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0JSUsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:48:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:40862 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab0JSUsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:48:30 -0400
Message-ID: <56111.84.105.60.153.1287521237.squirrel@gate.crashing.org>
In-Reply-To: <20101019181021.22456.qmail@kosh.dhis.org>
References: <20101019181021.22456.qmail@kosh.dhis.org>
Date: Tue, 19 Oct 2010 22:47:17 +0200 (CEST)
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Mel Gorman" <mel@csn.ul.ie>, linux-mm@kvack.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I made a new discovery.

And this nails it :-)

> So then I ran
>   dd if=/dev/mem bs=4 count=1 skip=$((0xfc5c080/4)) | od -t x4
> a few times very fast, plucking the first affected word directly out of
> memory by its physical address. The result:
>
> The low 16 bits are always zero as before. The high 16 bits are a counter,
> being incremented at about 1000Hz (as close as I could measure with a
> crude
> shell script. 1024Hz would also be within the margin of error). And it's
> little-endian.

> So what type of driver, firmware, or hardware bug puts a 16-bit 1000Hz
> timer
> in memory, and does it in little-endian instead of the CPU's native byte
> order? And why does it stop doing it some time during the early init
> scripts,
> shortly after the root filesystem fsck?

It looks like it is the frame counter in an USB OHCI HCCA.
16-bit, 1kHz update, offset x'80 in a page.

So either the kernel forgot to call quiesce on it, or the firmware
doesn't implement that, or the firmware messed up some other way.


Segher

