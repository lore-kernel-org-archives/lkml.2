Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab1KCR42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:56:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57468 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858Ab1KCR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <4EB2D0F2.40309@parallels.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <20111004150111.e9337268.akpm00@gmail.com> <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com>
 <20111028163021.1ce61f8a.akpm@linux-foundation.org> <CAA6-i6o0SPfZJDx4SRR1hY-He0L6zHuv0saH6EaE7Mrc2HF6PA@mail.gmail.com>
 <20111103164917.GF8198@somewhere.redhat.com> <4EB2C852.6020706@parallels.com>
 <CALdu-PDY8zpXYM3V9KRk4f2NyGevfNnuaWVdoT-qzSHOK--K3A@mail.gmail.com>
 <4EB2CA03.7030601@parallels.com> <CALdu-PA2CDoeUMoNd1y44p_QzphX8J4s6NDcSyVC-rP1HGYwkA@mail.gmail.com>
 <4EB2D0F2.40309@parallels.com>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 3 Nov 2011 10:56:04 -0700
X-Google-Sender-Auth: AmCrjnw0ZJlBhf5ubWMMXS46pLI
Message-ID: <CALdu-PDbJ69FayXSd-kjAMX8AKEroZytPapxsUn8GFsz-z1omQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
To: Glauber Costa <glommer@parallels.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Hockin <thockin@hockin.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 10:35 AM, Glauber Costa <glommer@parallels.com> wrote:
>
>> If multiple subsystems on the same hierarchy each need to
>> walk up the pointer chain on the same event, then after the first
>> subsystem has done so the chain will be in cache for any subsequent
>> walks from other subsystems.
>
> No, it won't. Precisely because different subsystems have completely
> independent pointer chains.

Because they're following res_counter parent pointers, etc, rather
than using the single cgroups parent pointer chain?

So if that's the problem, rather than artificially constrain
flexibility in order to improve micro-benchmarks, why not come up with
approaches that keep both the flexibility and the performance?

- make res_counter hierarchies be explicitly defined via the cgroup
parent pointers, rather than an parent pointer hidden inside the
res_counter. So the cgroup parent chain traversal would all be along
the common parent pointers (and res_counter would be one pointer
smaller).

- allow subsystems to specify that they need a small amount of data
that can be accessed efficiently up the cgroup chain. (Many subsystems
wouldn't need this, and those that do would likely only need it for a
subset of their per-cgroup data). Pack this data into as few
cachelines as possible, allocated as a single lump of memory per
cgroup. Each subsystem would know where in that allocation its private
data lay (it would be the same offset for every cgroup, although
dynamically determined at runtime based on the number of subsystems
mounted on that hierarchy)

Paul
