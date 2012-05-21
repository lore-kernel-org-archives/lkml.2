Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2EUS6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:58:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37733 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2EUS6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <4FB35C48.30708@cn.fujitsu.com>
References: <4FB35C48.30708@cn.fujitsu.com>
Date: Mon, 21 May 2012 11:58:51 -0700
Message-ID: <CAG7+5M2nc3qPAS-GvX=YoVKqwdwSGdesoBQ6nsksHp2LFfzYcQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
From: Eric Northup <digitaleric@google.com>
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:50 AM, zhangyanfei
<zhangyanfei@cn.fujitsu.com> wrote:
>
> This patch set exports offsets of VMCS fields as note information for
> kdump. We call it VMCSINFO. The purpose of VMCSINFO is to retrieve
> runtime state of guest machine image, such as registers, in host
> machine's crash dump as VMCS format. The problem is that VMCS internal
> is hidden by Intel in its specification. So, we slove this problem
> by reverse engineering implemented in this patch set. The VMCSINFO
> is exported via sysfs to kexec-tools just like VMCOREINFO.

Perhaps I'm wrong, but this solution seems much, much more dynamic
than it needs to be.

The VMCS offsets aren't going to change between different boots on the
same CPU, unless perhaps the microcode has been updated.

So you can have the VMCS offset dumping be a manually-loaded module.
Build a database mapping from (CPUID, microcode revision) -> (VMCSINFO).
There's no need for anything beyond the (CPUID, microcode revision) to
be put in the kdump, since your offline processing of a kdump can then
look up the rest.

It means you don't have to interact with the vmx module at all, and
no extra modules or code have to be loaded on the millions of Linux
machines that won't need the functionality.
