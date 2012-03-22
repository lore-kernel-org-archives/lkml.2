Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab2CVSvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:51:53 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:42818 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759074Ab2CVSvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:51:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sz7FhboVM1lMK62h1TxzSZRrQ8RArugeJUxRUj3EuFNjpkP
 Mimzn1HSQ5r0VLl4EW9AAKo6EXn2XPiWhINj8HyBA14eJl1gAd_6uCrdD5.4
 hnJalcfE0UhEoiiqq4FXwtkEYvs_TB9yLLHjI.he9XcWvG3iczu7rP674y8z
 r.Q0.WXxdFON8j9uOIdoJ7ZQyiynHzB9w9ug0SxUy1F7gSwrGKIydQtoU3oV
 ix5SBhlwj7ZIV.Ks8rZ2KDfL9uAyeIUjAlIJKKdcsQGi9DoeeXEbI278Go62
 wQsnHRdewTyIgMkTb2d4grOLUUp3hoQa0V0mHvTYlDGGJPSSUJwO8LPW3BBa
 UWSMixdtGbLK.ZVCO.zdQ9tBq6c4pyuqeH7E4KT_e1rNcZ6iWIAGIYqQw_vX
 4Pb3JfuEjERm3A_xfGajOIZ3BqwbDb6NJo5EC
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Mar 2012 13:51:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: lwoodman@redhat.com, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
In-Reply-To: <4F6B7358.60800@gmail.com>
Message-ID: <alpine.DEB.2.00.1203221348470.25011@router.home>
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, KOSAKI Motohiro wrote:

> CC to Christoph.
>
> > While moving tasks between cpusets I noticed some strange behavior.
> > Specifically if the nodes of the destination
> > cpuset are a subset of the nodes of the source cpuset do_migrate_pages()
> > will move pages that are already on a node
> > in the destination cpuset. The reason for this is do_migrate_pages() does
> > not check whether each node in the source
> > nodemask is in the destination nodemask before calling migrate_to_node(). If
> > we simply do this check and skip them
> > when the source is in the destination moving we wont move nodes that dont
> > need to be moved.
> >
> > Adding a little debug printk to migrate_to_node():
> >
> > Without this change migrating tasks from a cpuset containing nodes 0-7 to a
> > cpuset containing nodes 3-4, we migrate
> > from ALL the nodes even if they are in the both the source and destination
> > nodesets:
> >
> > Migrating 7 to 4
> > Migrating 6 to 3
> > Migrating 5 to 4
> > Migrating 4 to 3
> > Migrating 1 to 4
> > Migrating 3 to 4
> > Migrating 0 to 3
> > Migrating 2 to 3
>
> Wait.
>
> This may be non-optimal for cpusets, but maybe optimal migrate_pages,
> especially
> the usecase is HPC. I guess this is intended behavior. I think we need to hear
> Christoph's intention.
>
> But, I'm not against this if he has no objection.

The use case for this is if you have an app running on nodes 3,4,5 on your
machine and now you want to shift it to 4,5,6. The expectation is that the
location of the pages relative to the first node stay the same.
Application may manage their locality given a range of nodes and each of
the x .. x+n nodes has their particular purpose.

If you justd copy 3 to 6 then the app may get confused when doing
additional allocations since different types of information is now stored
on the "first" node (which is now 4).



