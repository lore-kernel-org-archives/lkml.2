Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1E0PcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:32:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49593 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab1E0PcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:32:01 -0400
MIME-Version: 1.0
Message-ID: <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
Date: Fri, 27 May 2011 08:31:40 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, sunil.mushran@oracle.com
Subject: RE: Cleancache and shared filesystems
References: <1306504300.2857.14.camel@menhir>
In-Reply-To: <1306504300.2857.14.camel@menhir>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DDFC3EE.000C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Whitehouse [mailto:swhiteho@redhat.com]
> Sent: Friday, May 27, 2011 7:52 AM
> Cc: linux-kernel@vger.kernel.org
> Subject: Cleancache and shared filesystems
> 
> Hi,
> 
> I'm trying to figure out what I would need to do in order to get GFS2
> to
> work with cleancache. Looking at the OCFS2 implementation leaves me
> with
> some questions about how this is supposed to work. The docs say that
> the
> cleancache_init_shared_fs() function is supposed to take a 128 bit UUID
> plus the sb.
> 
> In OCFS2 it is passed a pointer to a 32 bit little endian quantity as
> the UUID:
> 
> __le32 uuid_net_key;
> 
> ...
> 
> memcpy(&uuid_net_key, di->id2.i_super.s_uuid, sizeof(uuid_net_key));
> 
> ...
> 
> cleancache_init_shared_fs((char *)&uuid_net_key, sb);
> 
> and in the Xen backend driver this then appears to be dereferenced as
> if
> its two 64 bit values, which doesn't look right to me.

Hi Steve --

Thanks for looking at cleancache!

Hmmm... yes... it looks like you are right and the cleancache
interface code for ocfs2 has bit-rotted over time and a bad value
is being used for the uuid.  This would result in pages not being
shared between clustered VMs on the same physical machine, but
would only result in a lower performance advantage, not any
other visible effects, which would explain why it has gone
undiscovered for so long.

Thanks for pointing this out as it is definitely a bug!

> Also, since the sb has a UUID field in it anyway, is there some reason
> why that cannot be used directly rather than passing the uuid as a
> separate variable?

Forgive me but I am not a clustered FS expert (even for ocfs2):
If the UUID field in the sb is always 128-bits and is always
identical for all cluster nodes, and this fact is consistent
across all clustered FS's at mount time, I agree that there is
no need to pass the uuid as a parameter in
cleancache_init_shared_fs as it can be derived in the body of
cleancache_init_shared_fs and then passed to
__cleancache_init_shared_fs (which only cares that it gets
128-bits and probably has no business digging through a
superblock).  OTOH, this call is made only once per mount
so there's no significant advantage in changing this... or am
I missing something?

Thanks,
Dan

====

Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)

