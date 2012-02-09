Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2BITyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:54:04 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:39988 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754479Ab2BITyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:54:02 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oXn23rkVM1kAtU2mVukO1BSjIS.zdZaNpogL9oy2LuYsLJb
 Kr05v5NEYagM6jcu4pxHcvB9dkOAQpWPbyrJLNacABbdRtEw6c6FFTzPYRgn
 4l.Fgi6jNnr7FJDUi_zBaYAEEzvUo4IRRMDnotP2T98aiKnZygXskTOtXIiy
 JcUdsYPswd5kOFKvArvK.po.gCz0L5cBGDPvyYkEbR.EjFF61JdagIUR9D0R
 GLHLHPXjbgGz84Rot_Q4pd3r3Zaiz5zzFaDezC6tOrfH7Pdq4AT9axmvwQN9
 mtn9Pm1YTCJ77FeR22bCsFDe.ndw3iN3T_vULOwPmCzde2dJu0SmAJ3l9pyl
 WVzBqBXRTUbQAtLVecAz6lE8RGFoiuc65d7v0LgihzOhxNA3nvUnsHSME.VU
 lB8a9_3kc7yeLQYWtfd6mEBSNFV9Skn9KS_kk
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 9 Feb 2012 13:53:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <20120209125018.GN5938@suse.de>
Message-ID: <alpine.DEB.2.00.1202091345540.4413@router.home>
References: <1328568978-17553-1-git-send-email-mgorman@suse.de> <1328568978-17553-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1202071025050.30652@router.home> <20120208144506.GI5938@suse.de> <alpine.DEB.2.00.1202080907320.30248@router.home>
 <20120208163421.GL5938@suse.de> <alpine.DEB.2.00.1202081338210.32060@router.home> <20120208212323.GM5938@suse.de> <alpine.DEB.2.00.1202081557540.5970@router.home> <20120209125018.GN5938@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Mel Gorman wrote:

> Ok, I am working on a solution that does not affect any of the existing
> slab structures. Between that and the fact we check if there are any
> memalloc_socks after patch 12, the impact for normal systems is an additional
> branch in ac_get_obj() and ac_put_obj()

That sounds good in particular since some other things came up again,
sigh. Have not had time to see if an alternate approach works.

> > We have been down this road too many times. Logic is added to critical
> > paths and memory structures grow. This is not free. And for NBD swap
> > support? Pretty exotic use case.
> >
>
> NFS support is the real target. NBD is the logical starting point and
> NFS needs the same support.

But this is already a pretty strange use case on multiple levels. Swap is
really detrimental to performance. Its a kind of emergency outlet that
gets worse with every new step that increases the differential in
performance between disk and memory. On top of that you want to add
special code in various subsystems to also do that over the network.
Sigh. I think we agreed a while back that we want to limit the amount of
I/O triggered from reclaim paths? AFAICT many filesystems do not support
writeout from reclaim anymore because of all the issues that arise at that
level.

We have numerous other mechanisms that can compress swap etc and provide
ways to work around the problem without I/O which has always be
troublesome and these fixes are likely only to work in a very limited
way causing a lot of maintenance effort because (given the exotic
nature) it is highly likely that there are cornercases that only will be
triggered in rare cases.
