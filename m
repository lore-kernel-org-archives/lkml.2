Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1C2Tph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:45:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57841 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1C2Tpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HgOHGB1OQ0UuiGZwiXjV5OQS+m/LsZdOnTyQ1ggbtqPm3aRhV/L4VKqopb4H6NMXyF
         bj7oKsTvc8UkbW2w1DVtd0ItGpQs+RSfNL8dNpCypuhjz6Sx3X8OMkGqmm1vH3tqX374
         peoX0O0JlrnyL0Pd6FgBdspDnLjJ2dfu+dap0=
MIME-Version: 1.0
In-Reply-To: <1301421664.2151.12.camel@Portable-Work>
References: <1301310995.5615.92.camel@wangqingchuan>
	<1301336010.2217.20.camel@workstation>
	<AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
	<1301409864.5615.98.camel@wangqingchuan>
	<AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com>
	<1301421664.2151.12.camel@Portable-Work>
Date: Tue, 29 Mar 2011 15:45:34 -0400
Message-ID: <AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
From: Jerome Glisse <j.glisse@gmail.com>
To: Lucas Stach <dev@lynxeye.de>
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 2:01 PM, Lucas Stach <dev@lynxeye.de> wrote:
> Am Dienstag, den 29.03.2011, 11:23 -0400 schrieb Jerome Glisse:
>> 2011/3/29 r6144 <rainy6144@gmail.com>:
>> > 在 2011-03-29二的 10:22 -0400，Jerome Glisse写道：
>> >
>> >> Killer solution would be to have no mapping and a decent
>> >> upload/download ioctl that can take userpage.
>> >
>> > Doesn't this sound like GEM's read/write interface implemented by e.g.
>> > the i915 driver?  But if I understand correctly, a mmap-like interface
>> > should still be necessary if we want to implement e.g. glMapBuffer()
>> > without extra copying.
>> >
>> > r6144
>> >
>> >
>> glMapBuffer should not be use, it's really not a good way to do stuff.
>> Anyway the extra copy might be unavoidable given that sometime the
>> front/back might either be in unmappable vram or either have memory
>> layout that is not the one specify at buffer creation (this is very
>> common when using tiling for instance). So even considering MapBuffer
>> or a like function i believe it's a lot better to not allow buffer
>> mapping in userspace but provide upload/download hooks that can use
>> userpage to avoid as much as possible extra copy.
>>
>> Cheers,
>> Jerome
>>
>
> Wouldn't this give us a performance penalty for short lived resources
> like vbo's which are located in GART memory? Mmap allows us to write
> directly to this drm controlled portion of sysram. With a copy based
> implementation we would have to allocate the buffer in sysram just to
> copy it over to another portion of sysram which seems a little insane to
> me, but I'm not an expert here.
>
> -- Lucas

Short lived & small bo would definitly doesn't work well for this kind
of API, it would all be a function of the ioctl cost. But i am not
sure the drawback would be that big, intel tested with pread/pwrite
and gived up don't remember why. For the vbo case you describe the
scheme i was thinking would be : allocate bo and on buffer data call
upload to the allocated bo using the bind user page feature that would
mean zero extra copy operation. For the fire forget case of vbo,
likely somekind of transient buffer would be more appropriate.

Cheers,
Jerome
