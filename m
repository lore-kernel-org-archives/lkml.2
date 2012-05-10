Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab2EJXvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:51:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37786 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab2EJXvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:51:01 -0400
MIME-Version: 1.0
Message-ID: <8473859b-42f3-4354-b5ba-fd5b8cbac22f@default>
Date: Thu, 10 May 2012 16:50:30 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>, Konrad Wilk <konrad.wilk@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: RE: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <4FA33DF6.8060107@kernel.org> <20120509201918.GA7288@kroah.com>
 <4FAB21E7.7020703@kernel.org> <20120510140215.GC26152@phenom.dumpdata.com>
 <4FABD503.4030808@vflare.org> <4FABDA9F.1000105@linux.vnet.ibm.com>
 <20120510151941.GA18302@kroah.com> <4FABECF5.8040602@vflare.org>
 <20120510164418.GC13964@kroah.com> <4FABF9D4.8080303@vflare.org>
 <20120510173322.GA30481@phenom.dumpdata.com> <4FAC4E3B.3030909@kernel.org>
In-Reply-To: <4FAC4E3B.3030909@kernel.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> 
> Okay. Now it works but zcache coupled with zsmalloc tightly.
> User of zsmalloc should never know internal of zs_handle.
> 
> 3)
> 
> - zsmalloc.h
> void *zs_handle_to_ptr(struct zs_handle handle)
> {
> 	return handle.hanle;
> }
> 
> static struct zv_hdr *zv_create(..)
> {
> 	struct zs_handle handle;
> 	..
> 	handle = zs_malloc(pool, size);
> 	..
> 	return zs_handle_to_ptr(handle);
> }
> 
> Why should zsmalloc support such interface?
> It's a zcache problem so it's desriable to solve it in zcache internal.
> And in future, if we can add/remove zs_handle's fields, we can't make
> sure such API.

Hi Minchan --

I'm confused so maybe I am misunderstanding or you can
explain further.  It seems like you are trying to redesign
zsmalloc so that it can be a pure abstraction in a library.
While I understand and value abstractions in software
designs, the primary use now of zsmalloc is in zcache.  If
there are other users that require a different interface
or a more precise abstract API, zsmalloc could then
evolve to meet the needs of multiple users.  But I think
zcache is going to need more access to the internals
of its allocator, not less.  Zsmalloc is currently missing
some important functionality that (I believe) will be
necessary to turn zcache into an enterprise-ready,
always-on kernel feature.  If it evolves to add that
functionality, then it may no longer be able to provide
generic abstract access... in which case generic zsmalloc
may then have zero users in the kernel.

So I'd suggest we hold off on trying to make zsmalloc
"pretty" until we better understand how it will be used
by zcache (and ramster) and, if there are any, any future
users.

That's just my opinion...
Dan
