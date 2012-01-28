Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2A1AnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 19:43:11 -0500
Received: from mail2.seas.wustl.edu ([128.252.21.109]:10009 "EHLO
	POSTOFFICE.seas.wustl.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752088Ab2A1AnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 19:43:10 -0500
Message-ID: <4F234498.5070800@seas.wustl.edu>
Date: Fri, 27 Jan 2012 18:43:04 -0600
From: Professor Berkley Shands <berkley@seas.wustl.edu>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.0.18 tcsetattr on fd 0 when detached freezes system (RCU timeouts)
 (Centos 6.1 x86_64)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2012 00:43:09.0904 (UTC) FILETIME=[CED6BD00:01CCDD55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


typedef struct
{
    struct termios term;
} XKEY_DATA;

typedef XKEY_DATA *xkeyhandle;

static inline xkeyhandle xkeystart()
{

    // Turn off echo.
    struct termios temp;
    err = tcgetattr(0, &temp);
    if (err)
    {
       perror("tcgetattr failure");
    }

    XKEY_DATA *handle = new XKEY_DATA;
    handle->term = temp;

    temp.c_lflag &= ~ECHO;
    temp.c_lflag &= ~ICANON;

    err = tcsetattr(0, TCSANOW, &temp);        // this line causes the 
kernel to get very sick
    if (err)
    {
       perror("tcsetattr failure");
    }

    return handle;

}

The above code, called from main() will produce an error from tcsh:

/home/bshands> ./a.out > /dev/null &
[1] 3635
/home/bshands>
/home/bshands>
[1]  + Suspended (tty output) ./a.out > /dev/null
/home/bshands>

this does not appear on the redhat kernel, nor 2.6.32.43, but appeared 
infrequently in 3.0.9.
in 3.0.18, doing this in the background does *EVIL* things.

ssh system "./a.out > /dev/null &" &

Now when the code reaches the tcsetattr() the system quits scheduling tasks.
top shows 100%sy on 4/12 cores, kernel threads blocked, stalled tasks 
count increasing.


Jan 27 18:58:50 system kernel: [ 1269.891610] kjournald       S 
ffff880321270a30     0   416      2 0x00000000
Jan 27 18:58:50 system kernel: [ 1269.891684]  ffff880321f5de50 
0000000000000046 ffff880321270680 0000000000000000
Jan 27 18:58:50 system kernel: [ 1269.891816]  ffff880321270680 
0000000000012ac0 ffff880321f5dfd8 ffff880321f5c010
Jan 27 18:58:50 system kernel: [ 1269.891948]  ffff880321f5dfd8 
0000000000012ac0 ffff880327a61260 ffff880321270680
Jan 27 18:58:50 system kernel: [ 1269.892083] Call Trace:
Jan 27 18:58:50 system kernel: [ 1269.892144]  [<ffffffff824c126f>] 
schedule+0x3f/0x60
Jan 27 18:58:50 system kernel: [ 1269.892226]  [<ffffffffa0030f9d>] 
kjournald+0x20d/0x230 [jbd]
Jan 27 18:58:50 system kernel: [ 1269.892294]  [<ffffffff82082230>] ? 
wake_up_bit+0x40/0x40
Jan 27 18:58:50 system kernel: [ 1269.892362]  [<ffffffffa0030d90>] ? 
commit_timeout+0x10/0x10 [jbd]
Jan 27 18:58:50 system kernel: [ 1269.892431]  [<ffffffff82081bb6>] 
kthread+0x96/0xa0
Jan 27 18:58:50 system kernel: [ 1269.892497]  [<ffffffff824cbe04>] 
kernel_thread_helper+0x4/0x10
Jan 27 18:58:50 system kernel: [ 1269.892565]  [<ffffffff82081b20>] ? 
kthread_worker_fn+0x1a0/0x1a0
Jan 27 18:58:50 system kernel: [ 1269.892633]  [<ffffffff824cbe00>] ? 
gs_change+0x13/0x13

After a little while, the system locks up. rcu timeout errors may appear 
in dmesg.
dumps are available.

Note that this little bugger is a user mode crash, once started, you are 
done.
it appears that later use of termios is still sufficient to trigger the 
lockup.
they key is being detached.

Berkley





