Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab1DOSbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:31:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58735 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1DOSbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IgGeaG4nfo7VcbMalahxkBLzhpoNSPXoqUrgFN5tAfK/4kwG9yZ/em6ho7FiE7tiMk
         P2X2uTejaWphFtMOuvFGpsBUf+QBgtNfRJ5saU2MLwR9jRi5lOKHCkZ1UXfeXH56WM7G
         qzYvHizs5akoZJ2mJV5Th/wYZwRhMMPaAO+ks=
MIME-Version: 1.0
Date: Fri, 15 Apr 2011 13:30:59 -0500
Message-ID: <BANLkTi=eR9UiDSJp-Dhuv-DepeVYcP7PSg@mail.gmail.com>
Subject: feature query and optional features (was Re: 9p: revert tsyncfs
 related changes)
From: Eric Van Hensbergen <ericvh@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Branched into a new topic to discuss this aspect more closely.

On Fri, Apr 15, 2011 at 12:30 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Tue, 29 Mar 2011 11:05:08 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>> On Sun, Mar 27, 2011 at 5:24 PM, Venkateswararao Jujjuri
>> <jvrao@linux.vnet.ibm.com> wrote:
>> >
>> > Nice explanation. I looked at NFS and realized that they also follow
>> > write_inode approach.
>> > So I think you should make it explict that this will be helpful to dotl
>> > also and may and TFSYNCFS
>> > in the future if needed. With that I ack this.
>> >
>>
>> If this is something we really think we'll be adding back in the
>> future, is there someway we can conditionalize its use (default off
>> perhaps) so that if a particular server wanted to take advantage of
>> it, they could.  This would seem preferable to just backing out the
>> whole patch.
>
> It would be a nice feature to request the server for feature bits and
> then use different 9p operations with .L. ie if we can query the server
> and find out whether it supports tsyncfs then we can probably skip fsync
> during write_inode. The feature set is also useful to figure out which
> acl model the client should enforce if we start supporting multiple acl
> models and also to find out whether server also acl evaluation.
> So i guess we should do this once we have something similar to
> TFEATURE 9p operation
>

It seems to me there are three types of variation for operations:
   a) core operations which are there on every server (open, read, write, close)
   b) extended operations which may be there on a server (ie. xattr operations)
   c) variations of extended operations or their parameters (ie.
multiple ACL support)

For (b) & (c), there are actually a couple of potential cases:
   1) operations where it is acceptable to just fail the operation and
propagate the failure back to the user
   2) operations where the op that fails may be part of a bigger op
that can't be rolled back
   3) operations where we can fail the operation and try a different
alternative core or extended operation

I think when we originally talked about 9P.L as a community, the idea
was to do (1) or (3).  If (2) cases exist, this seems the be the best
justification for a new operation for feature negotiation or some form
of extension of the TVERSION string.

>>
>> Another aspect which I didn't consider when we added it is what it
>> would do to older versions of the servers which didn't have TFSYNCFS
>> -- maybe this is a good case study for the .L graceful degredation
>> plan we had talked about in the past where you try a tfsyncfs and if
>> the server returns an error that it doesn't implement it you back off
>> to another solution.
>>
>
> With the current Qemu server, the server aborts when it gets a 9p
> request that it didn't implement. That need to be fixed. Do you like to
> see the above done as a part of new set of operations that we are going
> to do, or are you suggesting that we need to do it for the existing set
> looking at when we added the 9p operations ?.
>

We need to take the current 9P.L set of operations and classify what
group they fall into (a), (b), or (c).
For (a), every server should support these.  For (b) or (c) we
probably should implement graceful degradation when simply propagating
the error back to the user isn't acceptable or won't work.

        -eric
