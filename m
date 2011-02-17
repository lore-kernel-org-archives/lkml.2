Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1BQX5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:57:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52763 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1BQX5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CWrbE+QCuUiF+p30cZM8lj6O0v9sCBLcqVdRW+umKuU63Kjru3IH7h3iPM/LE8k7wj
         K6q56syfjB0BH2Gq1sJg==
MIME-Version: 1.0
In-Reply-To: <20110217144643.0d60bef4.akpm@linux-foundation.org>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7ED1.2070601@cn.fujitsu.com>
 <20110217144643.0d60bef4.akpm@linux-foundation.org>
From: Paul Menage <menage@google.com>
Date: Thu, 17 Feb 2011 15:50:01 -0800
Message-ID: <AANLkTin6TqQMHSpQjNXNrgGAHG8DL6CvzhTm3KHoxv0y@mail.gmail.com>
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 2:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 17 Feb 2011 09:50:09 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>> +/*
>> + * In functions that can't propogate errno to users, to avoid declaring a
>> + * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
>> + * -ENOMEM, we use this global cpuset_mems.
>> + *
>> + * It should be used with cgroup_lock held.
>
> I'll do s/should/must/ - that would be a nasty bug.
>
> I'd be more comfortable about the maintainability of this optimisation
> if we had
>
>        WARN_ON(!cgroup_is_locked());
>
> at each site.
>

Agreed - that was my first thought on reading the patch. How about:

static nodemask_t *cpuset_static_nodemask() {
  static nodemask_t nodemask;
  WARN_ON(!cgroup_is_locked());
  return &nodemask;
}

and then just call cpuset_static_nodemask() in the various locations
being patched?

Paul
