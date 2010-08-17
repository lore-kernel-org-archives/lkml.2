Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0HQQDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:03:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab0HQQDP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100817144917.GD14091@sgi.com>
References: <20100722152220.GA18290@sgi.com> <20100724001449.GA9618@khazad-dum.debian.net>
 <20100817144917.GD14091@sgi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 09:02:21 -0700
Message-ID: <AANLkTinM7U-Vb0h5De9W54mHkBby7LZNztxLLQ=HuYdh@mail.gmail.com>
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
To: Jack Steiner <steiner@sgi.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mingo@elte.hu,
        tglx@linutronix.de, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 7:49 AM, Jack Steiner <steiner@sgi.com> wrote:
>
> I'm certainly not suggesting that ALL platforms map ACPI tables as WB. That
> would be a disaster. Only platforms where BIOS specifically reports that
> that tables are in WB memory should be mapped as MB.

Hmm. I actually suspect we _should_ map ACPI tables as WB all the
time. I'm not actually seeing any reason why we should ever map them
uncacheable, because as far as I can tell there are exactly two
realistic situations:

 - they are in RAM to begin with. I would pretty much expect this to
be true 99.9% of the time. Everybody uses compressed BIOS flash images
and uncompresses the image into RAM anyway, because (a) bigger flash
chips are another 25¢, so nobody can afford that on a PC motherboard
(b) the flash interface is ridiculously slow anyway, and you don't
want to execute your BIOS off it, and (c) the BIOS almost always
actually _changes_ the tables depending on various BIOS settings, so
mapping the tables as anything but RAM wouldn't work _anyway_.

 - even if they aren't in RAM, it's likely fine to let the dang things
be in the cache. On at least some platforms (old ones), if they aren't
in RAM, the system logic will override any MTRR/pageattribute issues
anyway.

So I think we should just map those things WB by default. Maybe with
some way to override it (possibly automatically). It sounds like it's
a big enough performance issue even on smaller systems (0.1 seconds is
quite a bit of the boot time on some systems).

                                    Linus
