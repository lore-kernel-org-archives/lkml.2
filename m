Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0KVKpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:45:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34169 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303Ab0KVKpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:45:07 -0500
Date: Mon, 22 Nov 2010 10:43:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Huang Ying <ying.huang@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC] persistent store
Message-ID: <20101122104312.23b6daea@lxorguk.ukuu.org.uk>
In-Reply-To: <1290391175.2903.132.camel@yhuang-dev>
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
	<1290391175.2903.132.camel@yhuang-dev>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > "reader" which iterates over all records currently in the
> > store - returning type, size and a record identifier as
> > well as the actual data.
> > 
> > "writer" which writes a record with a type to the persistent store
> 
> I think it is necessary to require this to be NMI safe (in comments?),
> because hardware error handler may need to write to persistent storage
> in NMI context. Or we can add a "flag" field to let storage provider
> advocate its capability of NMI safe.

One thing we need for some of the driver code sitting in the pending pile
is support for hardware assisted logging, where record numberes are handed
out by a device register access.

> > The "type" of error record I mentioned earlier is used to
> > name the files ... saved console logs from kmsg_dmp() are
> > named with a "dmesg" prefix as shown above.
> > 
> > Once an error record has been viewed, analysed, saved. The
> > user can request it to be cleared by writing its name to the
> > "erase" file:

How will fragmentation be handled ?

> The persistent storage may be full, and the writing may fail. So I think
> we can just try to write one by one, until the first success writing.

If you intend to treat it basically like an fs why not just make it a
file system. No more weird echo erase into magic sysfs file node you can
just use "rm".

The logging off an interrupt isn't a big problem either as you can have a
pool of blocks which are preallocated for the log files and more can be
stitched into the files asynchronously after the interrupt logging
events. For that matter you can keep it as a circular log just easily but
present it as a file system.

> [...]
> > + * Erase records by writing their filename to the "erase" file. E.g.
> > + *     # echo "dmesg-0" > erase

rm dmesg-0

We have a model for this and filesystem indirected via sysfs commands is
in the daft category.


