Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1EaVvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:51:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758298Ab1EaVvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:51:40 -0400
Date: Tue, 31 May 2011 17:51:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, xiyou.wangcong@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, jwilson@redhat.com
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Message-ID: <20110531215126.GW16382@redhat.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
 <20110203020703.GB21603@redhat.com>
 <20110203135324.93BC.A69D9226@jp.fujitsu.com>
 <20110526131028.7052a893.akpm@linux-foundation.org>
 <4DE3277D.8070109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE3277D.8070109@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 02:13:33PM +0900, KOSAKI Motohiro wrote:
> (2011/05/27 5:10), Andrew Morton wrote:
> > On Thu,  3 Feb 2011 13:53:01 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> >>>> I wrote why this is no good idea by another mail. Please see it.
> >>>> Anyway you have a right to don't use this feature.
> >>>>
> >>>
> >>> But you have not explained that why do you need to hook into crash_kexec()
> >>> and you have also not explained why do you need to send out kdump_msg()
> >>> notification if kdump is configured.
> >>>
> >>> Some detailed explanation here would help.
> >>
> >> Hi,
> >>
> >> I send it you now :)
> >>
> > 
> > What happened with this?  kexec-remove-kmsg_dump_kexec.patch has two acks
> > and one unexplained nack :(
> 
> http://groups.google.com/group/linux.kernel/browse_thread/thread/1084f406573d76ac/ee19e34b45f83536?lnk=raot&pli=1
> 
> At last mail, Vivek proposed move kms_dump() instead remove. and I asked following question and
> I've got no response. I'm still waiting his.
> 
> 
> > I'm sorry I've missed this mail long time. 
> > 
> >> > --------------------------------------------------------------------- 
> >> > @@ -74,6 +75,7 @@ NORET_TYPE void panic(const char * fmt, ...) 
> >> >         dump_stack(); 
> >> >  #endif 
> >> > +       kmsg_dump(KMSG_DUMP_PANIC); 
> >> >         /* 
> >> >          * If we have crashed and we have a crash kernel loaded let it handle 
> >> >          * everything else. 
> >> >          * Do we want to call this before we try to display a message? 
> >> >          */ 
> >> >         crash_kexec(NULL); 
> >> > --------------------------------------------------------------------- 
> >> And I think to compensate for that somebody introduced additional 
> >> kmsg_dump(KEXEC) call inside crash_kexec() and put it under CONFIG 
> >> option so that one can change the behavior based on config options. 
> >> I think this makes the logic somewhat twisted and an unnecessary call 
> >> inside crash_kexec(). So until and unless there is a strong reason we 
> >> can get rid of KEXEC event and move kmsg_dump call before crash_kexec() 
> >> for now and see how does it go, IMHO. 
> > 
> > 
> > I think I can agree your proposal. But could you please explain why do 
> > you think kmsg _before_ kdump and kmsg _in_ kdump are so different? 
> > I think it is only C level difference. CPU don't care C function and 
> > anyway the kernel call kmsg_dump() because invoke second kernel even 
> > if you proposal applied. 
> > It is only curious. I'm not against your proposal. 
> > Thanks. 

Few reasons.

- There is no correlation between crash_kexec() and kdump_msg(). What
  you are creating is equivalent of panic notifiers and calling those
  notifiers before dump happened. So calling it inside of crash_kexec()
  does not make much sense from code point of view.

- Why does somebody need to keep track of event KMSG_DUMP_KEXEC?

- There is one kernel CONFIG option introduce which looks completely
  superfluous.

My general take on the whole issue.

- In general I think exporting a hook to module so that they can do
  anything before crash is a bad idea. Now this can be overloaded to
  do things like sending crash notifications in clustered environement
  where we recommend doing it in second kernel.

- Even if we really have to do it, there seemed to be two concern
  areas.

	- Reliability of kdump_msg() generic infrastructure and its
  	  capability in terms of handling races with other cpus and
	  NMIs.

	- Reliability of module which is getting the callback from
	  kdump_msg().

 I think in one of the mails I was discussing that common infrastructure
 between kdump and kmsg_dump() can be put in a separate function, like
 stopping all cpus etc to avoid races in generic infrastrucutre and
 then first we can all kmsg_dump() and then crash_kexec().

 But this still does not provide us any protection against modules getting
 control after crash and possiblly worsen the situation.

Thanks
Vivek
