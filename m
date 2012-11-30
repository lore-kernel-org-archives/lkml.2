Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2K3X7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 18:59:44 -0500
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51334 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2K3X7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 18:59:43 -0500
Message-ID: <50B946A9.9070306@gmail.com>
Date: Fri, 30 Nov 2012 18:52:09 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>  <1350592007-9216-22-git-send-email-jslaby@suse.cz>  <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz>  <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>  <5091448D.3@suse.cz>  <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com>  <5093EC1B.2050800@suse.cz>  <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com>  <5093F262.6000301@suse.cz> <50947B7B.8080601@gmail.com>  <50953E8D.9000504@suse.cz> <5095A384.5080205@gmail.com>  <5095BC6E.2010505@gmail.com> <1354046255.2444.10.camel@thor>
In-Reply-To: <1354046255.2444.10.camel@thor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 02:57 PM, Peter Hurley wrote:
> On Sat, 2012-11-03 at 20:53 -0400, Sasha Levin wrote:
>> On 11/03/2012 07:06 PM, Sasha Levin wrote:
>>> On 11/03/2012 11:55 AM, Jiri Slaby wrote:
>>>> On 11/03/2012 03:03 AM, Sasha Levin wrote:
>>>>> On 11/02/2012 12:18 PM, Jiri Slaby wrote:
>>>>>> On 11/02/2012 05:07 PM, Sasha Levin wrote:
>>>>>>> On Fri, Nov 2, 2012 at 11:51 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>>>>>> On 10/31/2012 04:59 PM, Sasha Levin wrote:
>>>>>>>>> So you probably want a lot more than 100k syscalls, why limit it at
>>>>>>>>> all actually?
>>>>>>>>
>>>>>>>> I unset the limit but I still can't reproduce...
>>>>>>>>
>>>>>>>>> I've attached my .config for the guest kernel as reference.
>>>>>>>>
>>>>>>>> Even using this config does not help to reproduce that.
>>>>>>>>
>>>>>>>> Do you use some special trinity params?
>>>>>>>
>>>>>>> Not really:
>>>>>>>
>>>>>>>     ./trinity -m --quiet --dangerous -l off
>>>>>>
>>>>>> Oh, you run that as root??
>>>>>>
>>>>>>> Can I add something to my kernel to provide more info when it happens?
>>>>>>
>>>>>> Maybe the attached patch can tell us more...
>>>>>>
>>>>>
>>>>> Nope, I see the warnings mentioned before, without the new 'HUH' warnings.
>>>>
>>>> Actually it does. It is exactly as you wrote some time earlier. The work
>>>> is scheduled after is was cancelled and should not trigger anymore. Or,
>>>> it is scheduled before it is supposed to do. Could you try the attached
>>>> patch and report what happens with that patch?
>>>>
>>>> PS I can't reproduce by whatever I tried.
>>>>
>>>> thanks,
>>>>
>>>
>>> Interesting...
>>>
>>> [  388.783955] tty is bad=0 ops=          (null)Pid: 6480, comm: kworker/1:2 Tainted: G        W
>>> 3.7.0-rc3-next-20121102-sasha-00002-gbb570e0-dirty #111
>>
>> So after fuzzing for a while I'm also seeing these:
>>
>> [  603.533932] tty is bad=-2 ops=          (null)Pid: 37, comm: kworker/4:0 Tainted: G        W    3.7.0-rc3-next-20121102-sasha-000
>> 02-gbb570e0-dirty #112
> 
> Hi Sasha,
> 
> Assuming this access-after-free is still reproducible for you, would you
> be willing to try the patch below? I tried to reproduce this and
> couldn't (with multiple cores and with just single core).
> 
> It would distinguish between case A (that the buf work is not being
> cancelled) and case B (that the buf work is being scheduled after the
> port has already been freed). It should BUG in case B, which would also
> expose the call chain. It won't help at all in case A though :\
> 
> Regards,
> Peter Hurley
> 
> -- >% --
> Subject: [PATCH -next] tty: debug: Narrow possible causes of access-after-free
> 
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/pty.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index be6a373..893fe69 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -409,6 +409,7 @@ static void pty_cleanup(struct tty_struct *tty)
>  {
>  	tty->port->itty = NULL;
>  	tty_port_put(tty->port);
> +	tty->port = NULL;
>  }
>  
>  /* Traditional BSD devices */
> 

Still reproducible, I'm still seeing this with the patch above applied:

[ 1315.419759] ------------[ cut here ]------------
[ 1315.420611] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x60/0x200()
[ 1315.423098] tty is NULL
[ 1315.423885] Pid: 727, comm: kworker/0:1 Tainted: G        W    3.7.0-rc7-next-20121130-sasha-00015-g06fcc7a-dirty #2
[ 1315.427278] Call Trace:
[ 1315.428064]  [<ffffffff81c32ae0>] ? flush_to_ldisc+0x60/0x200
[ 1315.429898]  [<ffffffff8110dc56>] warn_slowpath_common+0x86/0xb0
[ 1315.431155]  [<ffffffff8110dce1>] warn_slowpath_fmt+0x41/0x50
[ 1315.433087]  [<ffffffff81c32ae0>] flush_to_ldisc+0x60/0x200
[ 1315.434972]  [<ffffffff811319e9>] process_one_work+0x3b9/0x780
[ 1315.436797]  [<ffffffff81131898>] ? process_one_work+0x268/0x780
[ 1315.438660]  [<ffffffff81c32a80>] ? __tty_buffer_request_room+0x180/0x180
[ 1315.440772]  [<ffffffff8113239a>] worker_thread+0x2ca/0x400
[ 1315.442012]  [<ffffffff811320d0>] ? rescuer_thread+0x2e0/0x2e0
[ 1315.443821]  [<ffffffff8113d0a3>] kthread+0xe3/0xf0
[ 1315.445362]  [<ffffffff811824be>] ? put_lock_stats.isra.16+0xe/0x40
[ 1315.447331]  [<ffffffff8113cfc0>] ? insert_kthread_work+0x90/0x90
[ 1315.449254]  [<ffffffff83cb107c>] ret_from_fork+0x7c/0xb0
[ 1315.450246]  [<ffffffff8113cfc0>] ? insert_kthread_work+0x90/0x90
[ 1315.455389] ---[ end trace 63e808312c27e968 ]---


Thanks,
Sasha
