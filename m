Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab2EZLVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 07:21:44 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:59311
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752647Ab2EZLVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 07:21:43 -0400
Date: Sat, 26 May 2012 13:21:38 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: compute KSA size and store in superblock
In-Reply-To: <1337952271.30969.37.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1205261303000.9892@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205251509220.2989@eristoteles.iwoars.net> <1337952271.30969.37.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I do not have to time to review it now, but please, make sure that the
> KSA size is according to 'max_leb_cnt' (see the --max-leb-cnt of the
> mkfs.ubifs tool).

Ahh, I see now I also need to add the min number of lebs to min_leb_cnt if
the feature is enabled.

> Also, think about this use-case in general: you have
> UBI volume of size X, then the volume is resized to Y > X, then mounted
> - UBIFS should work and resize itself to Y, up to the 'max_leb_cnt'. If
> Y > 'max_leb_cnt', we resize only to 'max_leb_cnt'.

For this case, it should be fine if the KSA is sized to maxlebcnt.
However, it will remain that size regardless of the real leb_cnt.

In general, removing KSA blocks is possible, but if datanodes are
encrypted with keys on those blocks, then they must be re-encrypted with a
different key on the smaller set (or somehow write the new last KSA block
containing all the used keys from the removed KSA blocks along with a
relocation table, but this seems like alot of coding if removing LEBs from
the KSA isn't that important.)

Adding LEBs to the KSA is very simple, just add a new entry on the list
and set all the key states to deleted--after purging will be random data;
but KSA LEBs are logically-sequential, so if it comes from used main LEBs
the data nodes need to be relocated. or some complicated code structure
involved in determining where a key for an out-of-range KSA block is
remapped.

Cheers,
Joel Reardon
