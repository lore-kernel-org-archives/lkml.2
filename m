Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab1I2OBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:01:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37844 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1I2OBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:01:05 -0400
MIME-Version: 1.0
Message-ID: <ae99a884-f63b-4258-afea-ca1d6cf5a74c@default>
Date: Thu, 29 Sep 2011 07:00:22 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com,
        levinsasha928@gmail.com
Subject: RE: [PATCH V10 0/6] mm: frontswap: overview (and proposal to merge at
 next window)
References: <20110915213305.GA26317@ca-server1.us.oracle.com>
 <20110928151558.dca1da5e.kamezawa.hiroyu@jp.fujitsu.com>
 <22173398-de03-43ef-abe4-a3f3231dd2e9@default
 20110929134816.7f29bf46.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110929134816.7f29bf46.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E847A06.0099:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Sent: Wednesday, September 28, 2011 10:48 PM
> 
> On Wed, 28 Sep 2011 07:09:18 -0700 (PDT)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > > Sent: Wednesday, September 28, 2011 12:16 AM
> > >
> > > I'm sorry I couldn't catch following... what happens at hibernation ?
> > > frontswap is effectively stopped/skipped automatically ? or contents of
> > > TMEM can be kept after power off and it can be read correctly when
> > > resume thread reads swap ?
> > >
> > > In short: no influence to hibernation ?
> > > I'm sorry if I misunderstand some.
> >
> > Hibernation would need to be handled by the tmem backend (e.g. zcache, Xen
> > tmem).  In the case of Xen tmem, both save/restore and live migration are
> > fully supported.  I'm not sure if zcache works across hibernation; since
> > all memory is kmalloc'ed, I think it should work fine, but it would be an
> > interesting experiment.
> 
> I'm afraid that users will lose data on memory of frontswap/zcache/tmem
> by power-off, hibernation. How about adding internal hooks to disable/sync
> frontswap itself before hibernation ? difficult ?

Hi Kame --

First, remember that frontswap is currently only enabled by
specifying a tmem backend as a kernel boot parameter ("zcache"
or "tmem"), so there is no risk of data loss to the average
laptop user doing hibernation, even if CONFIG_FRONTSWAP
and CONFIG_ZCACHE are enabled in their kernel.

The patchset's frontswap_shrink() call can be used to remove
pages from frontswap so there is one internal hook for this
already.

I still think hibernation should work fine with zcache
because all frontswap metadata and data is preserved as part
of kernel memory.  For poweroff, the normal swapoff will
"get" all frontswap pages, so no issue there either.
I do agree that this should be investigated before zcache
could be moved from staging and certainly before zcache is
enabled by default by a distro (with no kernel boot parameter).
If it turns out that zcache needs more hooks to provide finer
control of frontswap disable/sync, I don't think it will be 
difficult but I think those hooks should be designed in the future.

And Xen tmem supports save/restore and live migration
already so this is not a concern for the Xen tmem backend.

Hope that helps!

Thanks,
Dan
