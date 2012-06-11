Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2FKJno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:43:44 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:50132 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2FKJnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:43:43 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 13/16] hugetlb/cgroup: add hugetlb cgroup control files
In-Reply-To: <20120611090234.GE12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611090234.GE12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 15:13:31 +0530
Message-ID: <87bokq5gl8.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061109-3864-0000-0000-000003470BBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Sat 09-06-12 14:29:58, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> Add the control files for hugetlb controller
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
> [...]
>> +int __init hugetlb_cgroup_file_init(int idx)
>> +{
>> +	char buf[32];
>> +	struct cftype *cft;
>> +	struct hstate *h = &hstates[idx];
>> +
>> +	/* format the size */
>> +	mem_fmt(buf, 32, huge_page_size(h));
>> +
>> +	/* Add the limit file */
>> +	cft = &h->cgroup_files[0];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.limit_in_bytes", buf);
>> +	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
>> +	cft->read = hugetlb_cgroup_read;
>> +	cft->write_string = hugetlb_cgroup_write;
>> +
>> +	/* Add the usage file */
>> +	cft = &h->cgroup_files[1];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.usage_in_bytes", buf);
>> +	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
>> +	cft->read = hugetlb_cgroup_read;
>> +
>> +	/* Add the MAX usage file */
>> +	cft = &h->cgroup_files[2];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max_usage_in_bytes", buf);
>> +	cft->private = MEMFILE_PRIVATE(idx, RES_MAX_USAGE);
>> +	cft->trigger = hugetlb_cgroup_reset;
>> +	cft->read = hugetlb_cgroup_read;
>> +
>> +	/* Add the failcntfile */
>> +	cft = &h->cgroup_files[3];
>> +	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.failcnt", buf);
>> +	cft->private  = MEMFILE_PRIVATE(idx, RES_FAILCNT);
>> +	cft->trigger  = hugetlb_cgroup_reset;
>> +	cft->read = hugetlb_cgroup_read;
>> +
>> +	/* NULL terminate the last cft */
>> +	cft = &h->cgroup_files[4];
>> +	memset(cft, 0, sizeof(*cft));
>> +
>> +	WARN_ON(cgroup_add_cftypes(&hugetlb_subsys, h->cgroup_files));
>> +
>> +	return 0;
>> +}
>> +
>
> I am not so familiar with the recent changes in the generic cgroup
> infrastructure but isn't this somehow automated?

yes for most of the cgroups. But in the hugetlb case we have variable number
of control files. We have the above set of control files for each
hugetlb size supported by the architecture.

-aneesh

