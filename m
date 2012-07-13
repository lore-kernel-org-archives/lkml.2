Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2GMIi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:38:26 -0400
Received: from mga10.intel.com ([192.55.52.92]:14527 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756349Ab2GMIiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6X6PzXCy3a2DfctvAtiWDoO81-5AfRy7rN=qBBOytFYg@mail.gmail.com>
References: <1342114028-21407-1-git-send-email-octavian.purdila@intel.com>
	<CAErSpo6X6PzXCy3a2DfctvAtiWDoO81-5AfRy7rN=qBBOytFYg@mail.gmail.com>
Date: Fri, 13 Jul 2012 11:38:16 +0300
Message-ID: <CAE1zotK_R4QY9OoNCmfOx6+dm4R-DseB_nEsSmwaTGZNZM0nJg@mail.gmail.com>
Subject: Re: [PATCH v2] resource: make sure requested range is included in the
 root range
From: Octavian Purdila <octavian.purdila@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> Why don't you fix this right where the problem occurs, in
> __reserve_region_with_split(), with something like this:
>
>         if (end > conflict->start && conflict->start > start)
>                 __reserve_region_with_split(root, start,
> conflict->start-1, name);
>         if (start < conflict->end && conflict->end < end && )
>                 __reserve_region_with_split(root, conflict->end+1, end, name);
>

I am not sure this will behave properly in the overlapping cases.
Consider start=10, end=150, root->start=100, root->end=200.

In this case only the first condition above will be true (150 > 100 &&
100 > 10) and we will try to reserve  [10, 99] - which will return
nicely. But we will not reserve [100, 150].

But more important is the fact that by fixing the issue here we won't
be able to log the error and give a chance to upper layer fixing the
problem.

>> +               if (start > root->end || end < root->start) {
>> +                       abort = 1;
>> +                       pr_err("unable to fix request, aborting it\n");
>
> This message doesn't contain any useful information (range/root/etc).
>

Good point, I will remove it.
