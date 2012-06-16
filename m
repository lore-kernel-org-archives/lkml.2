Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2FPJBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 05:01:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:23348 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab2FPJBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 05:01:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166385085"
Date: Sat, 16 Jun 2012 17:01:09 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: automated warning notifications
Message-ID: <20120616090109.GA10332@localhost>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
 <20120615071222.GZ13539@mwanda>
 <20120615075810.GA13206@localhost>
 <alpine.DEB.2.02.1206150639130.1864@hadrien>
 <20120615111913.GA13539@mwanda>
 <20120615143403.GA18876@localhost>
 <CAM_iQpUPYpYVaZhCk-bfMe9ZvttQYaSYM_xfKJYX=Z494PWv+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUPYpYVaZhCk-bfMe9ZvttQYaSYM_xfKJYX=Z494PWv+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[drop sparse developers]

On Sat, Jun 16, 2012 at 03:50:36PM +0800, Cong Wang wrote:
> On Fri, Jun 15, 2012 at 10:34 PM, Fengguang Wu <wfg@linux.intel.com> wrote:
> > On Fri, Jun 15, 2012 at 02:19:14PM +0300, Dan Carpenter wrote:
> >>
> >> Probably we could use something like the attached script to print
> >> out the line of code which causes the bug and some other script to
> >> querry git blame and attach the offending commit?
> >
> > cat -n $code_file | tail -n +$(($lineno - (($context + 1) / 2))) | head -n $(($context + 1))
> >
> > That's handy, I'll use it to show the source file context for the
> > first error/warning :-)
> 
> Well, you can use sed/awk, it will be much shorter:
> 
> cat -n drivers/leds/led-triggers.c | sed -ne '224,230p'
>    224			struct led_classdev *led_cdev;
>    225	
>    226			led_cdev = list_entry(entry, struct led_classdev, trig_list);
>    227			led_set_brightness(led_cdev, brightness);
>    228		}
>    229		read_unlock(&trigger->leddev_list_lock);
>    230	}
> 
> (replace the hard-coded "224,230" with a shell variable)

Thanks!  I'll use it this way:

lineno=227
context=3
cat -n drivers/leds/led-triggers.c | sed -e "s/  $lineno\t/> $lineno\t/" -ne "$((lineno - context)),$((lineno + context))p"
   224                  struct led_classdev *led_cdev;
   225
   226                  led_cdev = list_entry(entry, struct led_classdev, trig_list);
 > 227                  led_set_brightness(led_cdev, brightness);
   228          }
   229          read_unlock(&trigger->leddev_list_lock);
   230  }

> And if you want to find the offending commit:
> 
> git show `git blame drivers/leds/led-triggers.c | awk 'NR==227{print $1}'`

The code offered by Peter should run faster:

        hash=$(git blame $code_file -L $lineno,$lineno |cut -d " " -f 1)
        git --no-pager show $hash $code_file

Anyway, Dan's original idea of using git blame to find out the offending 
commit is valuable. The process can be automated like this:

1) use git-blame to find out the commit that changed $lineno in recent 100 days
2) checkout out $commit and build test and check build error
3) checkout out $commit~1 and build test and check build error

If (1) succeeded and (2) got the expected build error while (3) don't
have the build error, we reliably catch the bad commit. Otherwise the
script may try building test other commits that modified the file
recently.

Thanks,
Fengguang
