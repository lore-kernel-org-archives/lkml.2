Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab1EXQWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:22:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58420 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1EXQWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=Zlzdp3SizDFex8UtongC0+q7GqNDmSJCcmQOGdGfkjCNtPGnBmdLxLGf0fC0pU0664
         WlzpyxYgs15Bb1BhG2NKjyzINdl0tyP+D9lBOY+8Rq/t6xffjCWay6Zjf2X4oFhFZJzj
         pbyjLriYn0wYy/3mJ9kST2gZeSmJkB5cz2+yo=
Message-ID: <4DDBDB4D.4080606@gmail.com>
Date: Tue, 24 May 2011 09:22:37 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: INFO: suspicious rcu_dereference_check() usage.
References: <4DDB491A.2070901@gmail.com> <BANLkTinC=2wxtYD4YmePgOfoLSh9STD6Sw@mail.gmail.com> <20110524155608.GA17977@redhat.com>
In-Reply-To: <20110524155608.GA17977@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 08:56 AM, Dave Jones wrote:
> On Mon, May 23, 2011 at 11:50:46PM -0700, Justin Mattock wrote:
>
>   >  [ 2862.310349] WARNING: at net/ipv4/route.c:1668 ip_rt_bug+0x5c/0x62()
>
> Awesome, adding that WARN_ON paid off. This is the same bug I've been trying
> to reproduce the last few weeks. DaveM mentioned that it means we used
> an input route for packet output.
>
>   >  [ 2862.310414] Pid: 6153, comm: gcm-session Not tainted
>   >  2.6.39-04906-g5e152b4-dirty #2
>   >  [ 2862.310417] Call Trace:
>   >  [ 2862.310424]  [<ffffffff8104c634>] warn_slowpath_common+0x83/0x9b
>   >  [ 2862.310430]  [<ffffffff8104c666>] warn_slowpath_null+0x1a/0x1c
>   >  [ 2862.310434]  [<ffffffff814095c9>] ip_rt_bug+0x5c/0x62
>   >  [ 2862.310439]  [<ffffffff814112a1>] dst_output+0x19/0x1d
>   >  [ 2862.310443]  [<ffffffff81412aa0>] ip_local_out+0x20/0x25
>   >  [ 2862.310448]  [<ffffffff814139c9>] ip_send_skb+0x19/0x58
>   >  [ 2862.310453]  [<ffffffff8142fa4e>] udp_send_skb+0x239/0x29b
>   >  [ 2862.310458]  [<ffffffff814310f0>] udp_sendmsg+0x5a1/0x7d4
>   >  [ 2862.310464]  [<ffffffff81079408>] ? trace_hardirqs_off+0xd/0xf
>   >  [ 2862.310469]  [<ffffffff8141139c>] ? ip_select_ident+0x3d/0x3d
>   >  [ 2862.310475]  [<ffffffff810525b8>] ? local_bh_enable_ip+0xe/0x10
>   >  [ 2862.310481]  [<ffffffff8148f131>] ? _raw_spin_unlock_bh+0x31/0x35
>   >  [ 2862.310486]  [<ffffffff813d41a6>] ? release_sock+0x14c/0x155
>   >  [ 2862.310490]  [<ffffffff814386ac>] inet_sendmsg+0x66/0x6f
>   >  [ 2862.310495]  [<ffffffff813d02b0>] sock_sendmsg+0xe6/0x109
>   >  [ 2862.310501]  [<ffffffff8107d63f>] ? lock_acquire+0xe1/0x109
>   >  [ 2862.310505]  [<ffffffff8107d535>] ? lock_release+0x1aa/0x1d3
>   >  [ 2862.310512]  [<ffffffff810ed549>] ? might_fault+0xa5/0xac
>   >  [ 2862.310516]  [<ffffffff813ceb34>] ? copy_from_user+0x2f/0x31
>   >  [ 2862.310521]  [<ffffffff813d1f34>] sys_sendto+0x132/0x174
>   >  [ 2862.310526]  [<ffffffff81495cfa>] ? sysret_check+0x2e/0x69
>   >  [ 2862.310531]  [<ffffffff8107b016>] ? trace_hardirqs_on_caller+0x13f/0x172
>   >  [ 2862.310537]  [<ffffffff8109fd4d>] ? audit_syscall_entry+0x11c/0x148
>   >  [ 2862.310542]  [<ffffffff8121debe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   >  [ 2862.310546]  [<ffffffff81495cc2>] system_call_fastpath+0x16/0x1b
>   >  [ 2862.310549] ---[ end trace 2d2332adaa8bf2b5 ]---
>   >  [ 2863.373889] ip_rt_bug: 10.0.0.10 ->  255.255.255.255, ?
>
> The common thing between your bug and the trace I triggered was the
> destination ip reported. A clue maybe ?
>
> 	Dave
>
>

there was a bug for http://marc.info/?l=linux-kernel&m=129913127722786&w=2
but looking I see something in there with recv.c not route.c but 
probably something
same or in the same vacinity. as for the sluggishness I have been 
noticing the system doing so, but
never saw anything like the above, so if it is your WARN_ON then kudos 
to you!

Justin P. Mattock
