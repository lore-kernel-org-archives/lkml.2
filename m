Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2IJSaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:30:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45772 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab2IJSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:30:09 -0400
MIME-Version: 1.0
In-Reply-To: <504E2B98.3010007@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
 <20120910090521.GB18544@redhat.com> <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
 <504E2B98.3010007@redhat.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 10 Sep 2012 14:29:48 -0400
Message-ID: <CAGTjWtDmS8Tjw1nWr8sw=u6KuBfDOmcdBnvcZpDDf32FW1_KrA@mail.gmail.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
To: Rik van Riel <riel@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Frank Swiderski <fes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 2:04 PM, Rik van Riel <riel@redhat.com> wrote:
> On 09/10/2012 01:37 PM, Mike Waychison wrote:
>>
>> On Mon, Sep 10, 2012 at 5:05 AM, Michael S. Tsirkin <mst@redhat.com>
>> wrote:
>
>
>>> Also can you pls answer Avi's question?
>>> How is overcommit managed?
>>
>>
>> Overcommit in our deployments is managed using memory cgroups on the
>> host.  This allows us to have very directed policies as to how
>> competing VMs on a host may overcommit.
>
>
> How do your memory cgroups lead to guests inflating their balloons?

The control loop that is driving the cgroup on the host can still move
the balloon target page count causing the balloon in the guest to try
and inflate.  This allows the host to effectively slowly grow the
balloon in the guest, allowing reclaim of guest free memory, followed
by guest page cache (and memory on the host system).  This can then be
compared with the subsequent growth (as this balloon setup allows the
guest to grow as it sees fit), which in effect gives us a memory
pressure indicator on the host, allowing it to back-off shrinking the
guest if the guest balloon quickly deflates.

The net effect is an opportunistic release of memory from the guest
back to the host, and the ability to quickly grow a VM's memory
footprint as the workload within it requires.

This dynamic memory sizing of VMs is much more in line with what we
can expect from native tasks today (and which is what our resource
management systems are designed to handle).
