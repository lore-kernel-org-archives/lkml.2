Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2ATC3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:29:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50941 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab2ATC3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:29:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        davem <davem@davemloft.net>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Hung task when calling clone() due to netfilter/slab
References: <1326558605.19951.7.camel@lappy>
	<1326561043.5287.24.camel@edumazet-laptop>
	<1326632384.11711.3.camel@lappy>
	<1326648305.5287.78.camel@edumazet-laptop>
	<alpine.DEB.2.00.1201170910130.4800@router.home>
	<1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.DEB.2.00.1201170927020.4800@router.home>
	<1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.DEB.2.00.1201170942240.4800@router.home>
	<alpine.DEB.2.00.1201171620590.14697@router.home>
	<m1bopz2ws3.fsf@fess.ebiederm.org> <m14nvr2vbu.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.1201191959540.14480@router.home>
Date: Thu, 19 Jan 2012 18:31:30 -0800
In-Reply-To: <alpine.DEB.2.00.1201191959540.14480@router.home> (Christoph
	Lameter's message of "Thu, 19 Jan 2012 20:03:51 -0600 (CST)")
Message-ID: <m1y5t3yuil.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX185gFy2Q5E0Qolu5TZV0B/n7LqTpHGaBUs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> On Thu, 19 Jan 2012, Eric W. Biederman wrote:
>
>> Oh.  I see.  The problem is calling kobject_uevent (which happens to
>> live in slabs sysfs_slab_add) with a lock held.  And kobject_uevent
>> makes a blocking call to userspace.
>>
>> No locks held seems to be a good policy on that one.
>
> Well we can just remove that call to kobject_uevent instead then. Does it
> do anything useful? Cannot remember why we put that in there.

Empirically it sounds like something is listening for it and doing cat
/proc/slabinfo.  Something like that would have to occur for their to be
a deadlock that was observed.

On the flip side removing from sysfs with locks held must be done
carefully, and as a default I would recommend not to hold locks over
removing things from sysfs.  As removal blocks waiting for all of the
callers into sysfs those sysfs attributes to complete.

It looks like you are ok on the removal because none of the sysfs
attributes appear to take the slub_lock, just /proc/slabinfo.  But
it does look like playing with fire.

Eric
