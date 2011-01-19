Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1ASWc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:32:28 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64465 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab1ASWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=F333Zi4xAUN6rMs01/cj9KTwZ7Q3ABC70k/6Vj7WvwS2dTYf9L59OnU0VG5UHrbtYG
         h94SoR+tGY0VcrLJEGh/yiWGLdYkONR7AxNBmIH32T3gBEIYafbJBKMYk4ukZpbsnl2G
         fhAXsW70XNVdscnU9ZT2eeyq02qBrKFr3iWmI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinVP=OuJ-3u9pHdDuuKJoVrP4Unr5Dx1x=qHtXC@mail.gmail.com>
References: <cover.1290852958.git.npiggin@kernel.dk>
	<d44ddcf1d1e0813b3ce2b3872c7c702a31b62894.1290852959.git.npiggin@kernel.dk>
	<AANLkTi=pj-pLYVSrU+6+BtioCWLod2ueZecNaap619fw@mail.gmail.com>
	<AANLkTik3ScP5rvR2bOXOEEH8SNZGg+xO6Gy32CW3XmU6@mail.gmail.com>
	<AANLkTinVP=OuJ-3u9pHdDuuKJoVrP4Unr5Dx1x=qHtXC@mail.gmail.com>
Date: Thu, 20 Jan 2011 09:32:24 +1100
Message-ID: <AANLkTimUjC8B0=nn5+yDshzp0hy6Zk1wxYHWEZbk83Tf@mail.gmail.com>
Subject: Re: [PATCH 17/46] fs: Use rename lock and RCU for multi-step operations
From: Nick Piggin <npiggin@gmail.com>
To: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 9:27 AM, Yehuda Sadeh Weinraub
<yehudasa@gmail.com> wrote:
> On Tue, Jan 18, 2011 at 2:42 PM, Nick Piggin <npiggin@gmail.com> wrote:
>> On Wed, Jan 19, 2011 at 9:32 AM, Yehuda Sadeh Weinraub
>
>>> There's an issue with ceph as it references the
>>> dentry->d_parent(->d_inode) at dentry_release(), so setting
>>> dentry->d_parent to NULL here doesn't work with ceph. Though there is
>>> some workaround for it, we would like to be sure that this one is
>>> really required so that we don't exacerbate the ugliness. The
>>> workaround is to keep a pointer to the parent inode in the private
>>> dentry structure, which will be referenced only at the .release()
>>> callback. This is clearly not ideal.
>>
>> Hmm, I'll have to think about it. Probably we can check for
>> d_count == 0 rather than parent != NULL I think?
>>
>
> That'll solve ceph's problem, don't know about how'd affect other
> stuff. We'll need to know whether this is the solution, or whether
> we'd need to introduce some other band aid fix.

No I think it will work fine. Basically we just need to know whether
we have been deleted, and if so then we restart rather than walking
back up the parent.

I'll send a patch in a few days. For the meantime, it's a rathe
small window for ceph to worry about. So we'll have something
before -rc2 which should be OK.
