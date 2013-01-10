Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3AJHLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:11:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:64721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab3AJHLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:11:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,442,1355126400"; 
   d="scan'208";a="272133555"
Date: Thu, 10 Jan 2013 15:12:23 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] kfifo: remove unnecessary type check
Message-ID: <20130110071223.GE304@yliu-dev.sh.intel.com>
References: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1357657073-27352-2-git-send-email-yuanhan.liu@linux.intel.com>
 <1357681864.27255.5.camel@wall-e>
 <20130109023503.GC304@yliu-dev.sh.intel.com>
 <1357745379.11538.4.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357745379.11538.4.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 04:29:39PM +0100, Stefani Seibold wrote:
> Am Mittwoch, den 09.01.2013, 10:35 +0800 schrieb Yuanhan Liu:
> > On Tue, Jan 08, 2013 at 10:51:04PM +0100, Stefani Seibold wrote:
> > > Am Dienstag, den 08.01.2013, 22:57 +0800 schrieb Yuanhan Liu:
> > > > Firstly, this kind of type check doesn't work. It does something similar
> > > > as following:
> > > > 	void * __dummy = NULL;
> > > > 	__buf = __dummy;
> > > > 
> > > > __dummy is defined as void *. Thus it will not trigger warnings as
> > > > expected.
> > > > 
> > > > Second, we don't need that kind of check. Since the prototype
> > > > of __kfifo_out is:
> > > > 	unsigned int __kfifo_out(struct __kfifo *fifo,  void *buf, unsigned int len)
> > > > 
> > > > buf is defined as void *, so we don't need do the type check. Remove it.
> > > > 
> > > 
> > > Thats wrong.
> > > 
> > > First the type checking will be used in kfifo_put() and kfifo_in() for
> > > const types to check if the passed type of the data can converted to the
> > > fifo element type. 
> > 
> > Hi Stefani,
> > 
> > Yes, I see now. After rechecking the code, I found that this kind of
> > type checking only works for those static defined kifo by
> > DECLARE/DEFINE_KFIFO. As the ptrtype is the same as the data type:
> > 
> >     /* the 4th argument "type" is "ptrtype" */
> >     #define STRUCT_KFIFO(type, size) struct __STRUCT_KFIFO(type, size, 0, type)
> > 
> >     #define DECLARE_KFIFO(fifo, type, size) STRUCT_KFIFO(type, size) fifo
> > 
> > While, for those kfifo dynamically allocated, the type checking will not
> > work as expected then as ptrtype is always "void":
> > 
> >     struct kfifo __STRUCT_KFIFO_PTR(unsigned char, 0, void);
> > 
> 
> You should avoid using struct kfifo, as you can read in kfifo.h this is
> only for compatibility reason.

Well, the fact is struct kfifo is used far more widely than
DECLARE/DEFINE_KFIFO; say above 50 vs less than 10.

Thanks.

	--yliu
> 
> If you use the macro DECLARE_KFIFO_PTR(), DECLARE_KFIFO() or
> DEFINE_KFIFO() instead.
> 
> Have a look at the examples files in the samples/kfifo directory.
> 
> - Stefani
> 
