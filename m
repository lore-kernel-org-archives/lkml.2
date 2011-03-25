Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1CYDvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 23:51:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1CYDvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 23:51:23 -0400
Date: Thu, 24 Mar 2011 23:47:11 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Roman Borisov <ext-roman.borisov@nokia.com>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: 2.6.35-rc4: mount results with and without MS_SILENT differ
Message-ID: <20110324234711.60a6e3c3@katamari>
In-Reply-To: <201103140520.08737.vda.linux@googlemail.com>
References: <201103140520.08737.vda.linux@googlemail.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 05:20:08 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

It looks like this bug has been there forever.

This fails:
> mount -vv --make-rshared mount.shared1               2>&1

This succeeds:
> mount -vv --loud --make-rshared mount.shared2               2>&1  # <-HERE

Failure case uses MS_REC | MS_SHARED | MS_SILENT
> mount: mount('','mount.shared1','',0x0010c000,''):0

It succeeds with MS_REC | MS_SHARED
> mount: mount('','mount.shared2','',0x00104000,''):0

Looking at do_mount() we see some flags get filtered out before checking
namespace flags:

        flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
                   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
                   MS_STRICTATIME);

Then:

        else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
                retval = do_change_type(&path, flags);

In do_change_type()

        type = flags_to_propagation_type(flag);
        if (!type)
                return -EINVAL;

And flags_to_propagation_type() filters out MS_REC before making sure one
and only one of the propagation type flags is set:

        int type = flags & ~MS_REC;

        /* Fail if any non-propagation flags are set */
        if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
                return 0;
        /* Only one propagation flag should be set */
        if (!is_power_of_2(type))
                return 0;

Looks like the is_power_of_2() test is failing because MS_SILENT is set.
I'm not sure whether to filter MS_SILENT in the upper or lower function
though.
