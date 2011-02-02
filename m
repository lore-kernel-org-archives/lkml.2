Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab1BBTfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:35:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:33324 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab1BBTfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:35:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,415,1291622400"; 
   d="scan'208";a="598877368"
Date: Wed, 2 Feb 2011 11:32:53 -0800
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: container cgroup <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [RFC PATCH 2/2] cgroup/freezer: add per freezer duty ratio
 control
Message-ID: <20110202113253.789a2a85@putvin>
In-Reply-To: <20110201142301.GA23803@shutemov.name>
References: <1291230012-9536-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1291230012-9536-3-git-send-email-jacob.jun.pan@linux.intel.com>
	<20110201142301.GA23803@shutemov.name>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 16:23:01 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

Thanks for your review, I will fix the error handling. Please also see
my comments on create vs populate.
> On Wed, Dec 01, 2010 at 11:00:12AM -0800,
> jacob.jun.pan@linux.intel.com wrote:
> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
>
> > +#define FREEZER_KH_PREFIX  "freezer_"
> >  static int freezer_populate(struct cgroup_subsys *ss, struct
> > cgroup *cgroup) {
> > +	int ret = 0;
> > +	char thread_name[32];
> > +	struct freezer *freezer;
> > +
> >  	if (!cgroup->parent)
> >  		return 0;
> > -	return cgroup_add_files(cgroup, ss, files,
> > ARRAY_SIZE(files)); +
> > +	freezer = cgroup_freezer(cgroup);
> > +	ret = cgroup_add_files(cgroup, ss, files,
> > ARRAY_SIZE(files)); +
> > +	snprintf(thread_name, 32, "%s%s", FREEZER_KH_PREFIX,
> > +		cgroup->dentry->d_name.name);
> > +	freezer->fkh = kthread_run(freezer_kh, (void *)cgroup,
> > thread_name);
> > +	if (!IS_ERR(freezer_task))
> > +		return 0;
> > +	return ret;
> 
> Why do you create on freezer_populate, not on freezer_create?
I want to use the cgroup directory name for the kernel thread. If I do
that in create() instead of populate, I would have to add more changes:
1. pass dentry to the create function since that is called before
  cgroup_create_dir()
2. skip the dummy root as part of the initialization.
So I chose to use populate, are there any issues with the functionality?

