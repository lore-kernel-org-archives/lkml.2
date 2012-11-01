Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab2KAPde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:33:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44780 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2KAPdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:33:32 -0400
MIME-Version: 1.0
Message-ID: <d7588a48-9f47-4f3a-852c-3fac916de75c@default>
Date: Thu, 1 Nov 2012 08:30:05 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, minchan@kernel.org,
        fschmaus@gmail.com, andor.daam@googlemail.com, ilendir@googlemail.com,
        akpm@linux-foundation.org, mgorman@suse.de
Subject: RE: [PATCH 2/5] mm: frontswap: lazy initialization to allow tmem
 backends to build/run as modules
References: <1351696074-29362-1-git-send-email-dan.magenheimer@oracle.com>
 <1351696074-29362-3-git-send-email-dan.magenheimer@oracle.com>
 <50915A5C.8000303@linux.vnet.ibm.com>
In-Reply-To: <50915A5C.8000303@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH 2/5] mm: frontswap: lazy initialization to allow tmem backends to build/run as
> modules
> 
> >  static int __init init_frontswap(void)
> >  {
> > +	int i;
> >  #ifdef CONFIG_DEBUG_FS
> >  	struct dentry *root = debugfs_create_dir("frontswap", NULL);
> >  	if (root == NULL)
> > @@ -364,6 +414,10 @@ static int __init init_frontswap(void)
> >  	debugfs_create_u64("invalidates", S_IRUGO,
> >  				root, &frontswap_invalidates);
> >  #endif
> > +	for (i = 0; i < MAX_INITIALIZABLE_SD; i++)
> > +		sds[i] = -1;
> > +
> > +	frontswap_enabled = 1;
> 
> If frontswap_enabled is going to be on all the time, then what point
> does it serve?  By extension, can all of the static inline wrappers in
> frontswap.h be done away with?

The intent of frontswap_enabled and cleancache_enabled was
to avoid the overhead of a function call at the point where
each frontswap/cleancache "hooks" is placed, using a global
variable check instead.  I'm not sure if this minor
performance tuning effort is worth preserving:  If not,
I agree frontswap_enabled and the static inline wrappers (as
well as their cleancache brethren) could be done away with **;
if worth preserving, then I think frontswap_enabled could
be set in the init method instead but the check for enabled
in the frontswap init method and the cleancache init_fs
method would need to be removed else lazy initialization
wouldn't work.

Dan

** Note to anyone that tries this:  There is a subtle but
clever hack in the wrappers suggested by Jeremy Fitzhardinge
that disables the wrappers at compile-time as well as
runtime.  IOW, make sure you test-compile both with
CONFIG_{CLEANCACHE|FRONTSWAP} _and_ with them unconfig'd.

