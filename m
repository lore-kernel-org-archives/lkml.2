Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1IVGA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:00:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36973 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1IVGA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:00:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=kqx1oKSuL4x3Drua/pyMPbnQ5ryHLx+FX8ATnNhQHlAvMC8ESDgwKMjl9ZB3LYqyA
	xxzhVDac26vs3sRMcx2mw==
MIME-Version: 1.0
In-Reply-To: <4E7A342B.5040608@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
 <1316393805-3005-3-git-send-email-glommer@parallels.com> <CAHH2K0YgkG2J_bO+U9zbZYhTTqSLvr6NtxKxN8dRtfHs=iB8iA@mail.gmail.com>
 <4E7A342B.5040608@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 21 Sep 2011 23:00:18 -0700
Message-ID: <CAHH2K0Z_2LJPL0sLVHqkh_6b_BLQnknULTB9a9WfEuibk5kONg@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] socket: initial cgroup code.
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:59 AM, Glauber Costa <glommer@parallels.com> wrote:
> Right now I am working under the assumption that tasks are long lived inside
> the cgroup. Migration potentially introduces some nasty locking problems in
> the mem_schedule path.
>
> Also, unless I am missing something, the memcg already has the policy of
> not carrying charges around, probably because of this very same complexity.
>
> True that at least it won't EBUSY you... But I think this is at least a way
> to guarantee that the cgroup under our nose won't disappear in the middle of
> our allocations.

Here's the memcg user page behavior using the same pattern:

1. user page P is allocate by task T in memcg M1
2. T is moved to memcg M2.  The P charge is left behind still charged
to M1 if memory.move_charge_at_immigrate=0; or the charge is moved to
M2 if memory.move_charge_at_immigrate=1.
3. rmdir M1 will try to reclaim P (if P was left in M1).  If unable to
reclaim, then P is recharged to parent(M1).
