Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1CIP5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:57:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab1CIP5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:57:49 -0500
Date: Wed, 9 Mar 2011 12:57:24 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Lin Ming <minggr@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Han Pingtian <phan@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Franck Bui-Huu <fbuihuu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf: Avoid resolving [kernel.kallsyms] to real path
	for buildid cache
Message-ID: <20110309155724.GB14438@ghostprotocols.net>
References: <1299165837-27817-1-git-send-email-ming.m.lin@intel.com> <AANLkTikMi0TR9pUSG3bWdRvEOwKdFQ-5Ex5trjGEQBx0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikMi0TR9pUSG3bWdRvEOwKdFQ-5Ex5trjGEQBx0@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 09, 2011 at 10:38:52PM +0800, Lin Ming escreveu:
> Hi, Arnaldo
> 
> Could you have a look at this patch?
> 
> Thanks,
> Lin Ming

Seems ok, problem was introduced in:

commit 68a7a771ad0e2959983729bf88cbc74a7014438f
Author: Franck Bui-Huu <fbuihuu@gmail.com>
Date:   Fri Dec 10 22:06:26 2010 +0100

    perf buildid-cache: Fix symbolic link handling
    
    This was broken since link(2) doesn't dereference symbolic
    links. Instead 'filename' becomes a symbolic link to the same file
    that 'name' refers to.
    
    This had the bad effect to create dangling symlinks in the case that
    even can't be removed with perf-buildid-cache(1).
    
    LKML-Reference: <m38vzxxrql.fsf@gmail.com>
    Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

[acme@emilia linux]$ git describe 68a7a771
v2.6.37-rc5-71-g68a7a77

So I'll add a CC: stable@kernel.org when pushing to perf/urgent.

- Arnaldo

 
> On Thu, Mar 3, 2011 at 11:23 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > kallsyms has a virtual file name [kernel.kallsyms].
> > Currently, it can't be added to buildid cache successfully
> > because the code(build_id_cache__add_s) tries to resolve
> > [kernel.kallsyms]to a real absolute pathname and that fails.
> >
> > Fixes it by not resolving it and just use the name [kernel.kallsyms].
> > So dir ~/.debug/[kernel.kallsyms] is created.
> >
> > Original bug report at:
> > https://lkml.org/lkml/2011/3/1/524
> >
> > Tested-by: Han Pingtian <phan@redhat.com>
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  tools/perf/util/header.c |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > index 72c124d..1f8883b 100644
> > --- a/tools/perf/util/header.c
> > +++ b/tools/perf/util/header.c
> > @@ -271,11 +271,15 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
> >                          const char *name, bool is_kallsyms)
> >  {
> >        const size_t size = PATH_MAX;
> > -       char *realname = realpath(name, NULL),
> > -            *filename = malloc(size),
> > +       char *realname, *filename = malloc(size),
> >             *linkname = malloc(size), *targetname;
> >        int len, err = -1;
> >
> > +       if (is_kallsyms)
> > +               realname = (char *)name;
> > +       else
> > +               realname = realpath(name, NULL);
> > +
> >        if (realname == NULL || filename == NULL || linkname == NULL)
> >                goto out_free;
> >
> > @@ -307,7 +311,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
> >        if (symlink(targetname, linkname) == 0)
> >                err = 0;
> >  out_free:
> > -       free(realname);
> > +       if (!is_kallsyms)
> > +               free(realname);
> >        free(filename);
> >        free(linkname);
> >        return err;
> > --
> > 1.7.2.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
