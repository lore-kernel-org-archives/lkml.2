Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1BHNJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:09:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40996 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752954Ab1BHNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:09:50 -0500
Date: Tue, 8 Feb 2011 13:13:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support
Message-ID: <20110208131321.6ceb9a43@lxorguk.ukuu.org.uk>
In-Reply-To: <20110208122534.19110.89437.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122534.19110.89437.sendpatchset@linux-mhg7.site>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Feb 2011 13:25:34 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> >From 11bed7feff5de752c9440ca58b232846b20e2ed6 Mon Sep 17 00:00:00 2001
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 8 Feb 2011 12:39:28 +0100
> Subject: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support
> 
> Add EFAR SLC90E66 support to ata_piix and remove no longer
> needed pata_efar driver.

Jeff specifically asked that these were not all folded into ata_piix
originally. This also makes memory usage higher and the system less
efficient as these are all motherboard chipsets (except an obscure dual
PIIX4 setup) so you are loading more not less code.

It also leads to hideous uglies in the main code paths like this :

+	unsigned int has_sitre	= (dev->vendor != 0x8086 ||
+				   dev->device != 0x1230);

which also has exactly zero comments.

and it gets better as we go on...

+	unsigned int is_radisys	= (dev->vendor ==
  PCI_VENDOR_ID_RADISYS &&
+				   dev->device == 0x8201);
+	unsigned int has_sitre	= (dev->vendor !=
  PCI_VENDOR_ID_INTEL ||
+				   dev->device != 0x1230) && !is_radisys;


Folding these together just makes no sense at all. The PIO/DMA folds
internally do look sensible, but really should be tested before anything
goes in. The current code works - its slower than it should be because of
core libata bugs, but it works.

Alan
