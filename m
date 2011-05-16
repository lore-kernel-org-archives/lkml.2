Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1EPUme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:42:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49954 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1EPUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:42:32 -0400
In-Reply-To: <20110516.140359.111037536766782557.davem@davemloft.net>
References: <20110515165945.GA20024@darkmag.usersys.redhat.com> <20110516.140359.111037536766782557.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: jmorris@namei.org, kaber@trash.net, kuznet@ms2.inr.ac.ru,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        mmarek@suse.cz, netdev@vger.kernel.org, pekkas@netcore.fi,
        vfalico@redhat.com, yoshfuji@linux-ipv6.org
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] igmp: fix ip_mc_clear_src to not reset ip_mc_list->sf{mode,count}
X-KeepSent: 948388D5:90B3F5A7-88257892:006C3228;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.1FP5 SHF29 November 12, 2010
From: David Stevens <dlstevens@us.ibm.com>
Message-ID: <OF948388D5.90B3F5A7-ON88257892.006C3228-88257892.0071B9D5@us.ibm.com>
Date: Mon, 16 May 2011 13:42:11 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 8.5.1FP2|March 17, 2010) at
 05/16/2011 14:42:12,
	Serialize complete at 05/16/2011 14:42:12
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Veaceslav Falico <vfalico@redhat.com>
> Date: Sun, 15 May 2011 18:59:45 +0200
> 
> > ip_mc_clear_src resets the imc->sfcount and imc->sfmode, without 
taking into
> > account the current number of sockets listening on that multicast 
> struct, which
> > can lead to bogus routes for local listeners.
> > 
> > On NETDEV_DOWN/UP event, if there were 3 multicast listeners for 
> that interface's
> > address, the imc->sfcount[MCAST_EXCLUDE] will be reset to 1. And 
> after that a
> > listener socket destroys, multicast traffic will not be delivered to 
local
> > listeners because __mkroute_output drops the local flag for the route 
(by
> > checking ip_check_mc).

        On NETDEV_DOWN, all group memberships are dropped. 
ip_mc_clear_src()
is simply freeing all the source filters and turning it into an "EXCLUDE 
nobody"
membership (ie, the same as an ordinary join without source filtering). 
This
ordinarily happens when you are deleting the group entirely (when the 
reference
count goes to 0), but is also called on device down.
        This patch is not appropriate; when the groups are deleted, the 
source
filters are deleted, and the filter counts have to reflect the source 
filters
in the list. If you had an "INCLUDE A" filter, for example, that would 
become
an "INCLUDE nobody" filter and drop all traffic (from A or not). The 
number
of source filters is not related to the number of listener sockets, and 
the
function of ip_mc_clear_src() is to make it 0 (with the special case of 1 
for
EXCLUDE), so setting the counts has to be done for proper functioning.
        I don't quite understand the problem you're trying to solve here 
--
when the device comes back up, the group should be re-added with 
{EXCLUDE,nobody} and
ip_check_mc() should therefore return 1. Of course, while the interface is
down, the mc_list is empty and it'd return 0 in that case.
        Do you have a small test program to demonstrate the problem?

        For the patch, I have to say NACK.

                                                                +-DLS


