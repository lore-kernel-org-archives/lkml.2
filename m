Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2EYKqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:46:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:26785 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab2EYKql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:46:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171254787"
Date: Fri, 25 May 2012 12:02:16 +0100
From: Alan Cox <alan@linux.intel.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.4+ tty lockdep trace
Message-ID: <20120525120216.45381ec6@bob.linux.org.uk>
In-Reply-To: <CA+1xoqemV-zsM3wZKDrirNopqVoH7PbHKijFCGQK2HuSDAN+CA@mail.gmail.com>
References: <20120523002645.GA3490@redhat.com>
	<CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
	<CA+1xoqf0G3kDY3c4Gb=RkQZ8_L+but6-uUjtSVfvYUf6iL2_JA@mail.gmail.com>
	<20120524121056.24fbdcdb@pyramind.ukuu.org.uk>
	<CA+1xoqegLYLsP5yWw7d7oMngUSgZjXePJu_b6E-yw4aBE8Qhgg@mail.gmail.com>
	<CA+1xoqc3MrwfDnf9iCRLCedapZOtOfmBb6E84ORgwmdP1fx8QA@mail.gmail.com>
	<CA+1xoqeD3yyOgmLe_eQ_PS=HJA=93Syidtk6rq-K9dBoC-DOzQ@mail.gmail.com>
	<20120524155457.56e37df2@bob.linux.org.uk>
	<20120525023222.GC30024@home.goodmis.org>
	<CA+1xoqfCQutidqdwb3ysCtajHF2r0zNLc4H+X7cYpxrmjoqAvg@mail.gmail.com>
	<CACVXFVNB+=EniGofYV2eMy8m521aNbs4MJETEFEwTK7LMpK6LA@mail.gmail.com>
	<CA+1xoqemV-zsM3wZKDrirNopqVoH7PbHKijFCGQK2HuSDAN+CA@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applying Ming's patch over Alan's 2 patches from yesterday, I'm still
> seeing two lockdep warnings. Full trace attached.

In that code path we've just succesfully done

	tty_lock_pair(tty, o_tty)

(no warning issued)

We've then called into tty_ldisc_release which has done

	tty_unlock_pair(tty, o_tty);

and then

	tty_lock_pair(tty, o_tty);

which can't error unless our locking hosed

and at that point we then then do a recursive

	tty_ldisc_release(o_tty, NULL)

which embarrassingly already has a comment above it I put there saying


        /* This will need doing differently if we need to lock */


Let me go rewrite that particular routine to make sense with the
locking in place.

