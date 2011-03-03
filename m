Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1CCEUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 23:20:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:26791 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807Ab1CCEUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 23:20:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="893238462"
Subject: Re: perf archive warning
From: Lin Ming <ming.m.lin@intel.com>
To: Han Pingtian <phan@redhat.com>
Cc: "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110303042150.GA3025@hpt.nay.redhat.com>
References: <20110302042354.GB5186@hpt.nay.redhat.com>
	 <AANLkTim+Ls+_cbHnMzdfWAWUj0Wx2rQtnoTCjZJ8Cnro@mail.gmail.com>
	 <1299054581.8642.36.camel@minggr.sh.intel.com>
	 <20110302085355.GA9857@hpt.nay.redhat.com>
	 <1299112705.8642.42.camel@minggr.sh.intel.com>
	 <20110303042150.GA3025@hpt.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 12:21:01 +0800
Message-ID: <1299126061.8642.46.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 12:21 +0800, Han Pingtian wrote:
> On Thu, Mar 03, 2011 at 08:38:25AM +0800, Lin Ming wrote:
> > On Wed, 2011-03-02 at 16:53 +0800, Han Pingtian wrote:
> > > On Wed, Mar 02, 2011 at 04:29:41PM +0800, Lin Ming wrote:
> > > > > 
> > > > > root@intel-s3e36-01 perf]# ./perf-archive
> > > > > tar: .build-id/b2/370e39ea2898c6e11c188e2f3879e4e3d6d1ef: Cannot stat:
> > > > > No such file or directory
> > > > > tar: .build-id/b2/370e39ea2898c6e11c188e2f3879e4e3d6d1ef: Cannot stat:
> > > > > No such file or directory
> > > > > tar: Exiting with failure status due to previous errors
> > > > 
> > > > kernel.kallsyms is not created successfully in the buildid-cache.
> > > > Could you have a try below patch?
> > > > 
> > > > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > > > index 72c124d..d3b5062 100644
> > > > --- a/tools/perf/util/header.c
> > > > +++ b/tools/perf/util/header.c
> > > > @@ -271,11 +271,16 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
> > > >  			  const char *name, bool is_kallsyms)
> > > >  {
> > > >  	const size_t size = PATH_MAX;
> > > > -	char *realname = realpath(name, NULL),
> > > > +	char *realname,
> > > >  	     *filename = malloc(size),
> > > >  	     *linkname = malloc(size), *targetname;
> > > >  	int len, err = -1;
> > > >  
> > > > +	if (is_kallsyms)
> > > > +		realname = (char *)name;
> > > > +	else
> > > > +		realname = realpath(name, NULL);
> > > > +
> > > >  	if (realname == NULL || filename == NULL || linkname == NULL)
> > > >  		goto out_free;
> > > >  
> > > > @@ -307,7 +312,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
> > > >  	if (symlink(targetname, linkname) == 0)
> > > >  		err = 0;
> > > >  out_free:
> > > > -	free(realname);
> > > > +	if (!is_kallsyms)
> > > > +		free(realname);
> > > >  	free(filename);
> > > >  	free(linkname);
> > > >  	return err;
> > > > 
> > > The patch didn't fix this problem. 
> > 
> > Did you re-run perf command?
> > Need to re-run it to generate kernel.kallsyms build-id cache.
> > 
> > For example, 
> > 
> > $ perf record -- sleep 3
> > $ perf-archive
> I think I must do something wrong yesterday when testing your patch. It
> works just fine today, the problem has been fixed by it. Thanks! 

OK. I'll send out a patch with your Tested-by.

Lin Ming

