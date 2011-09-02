Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1IBSEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:04:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33504 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1IBSEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110902143549.GA17970@ghostprotocols.net>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-2-git-send-email-jim.cromie@gmail.com> <20110521103418.GB23651@elte.hu>
 <20110521204148.GB10330@ghostprotocols.net> <CAJfuBxzhjhuGRfqW-qXFhNN+X6n_puaVS+-AbZN2NjUQGou3Jw@mail.gmail.com>
 <20110902143549.GA17970@ghostprotocols.net>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 2 Sep 2011 12:04:03 -0600
Message-ID: <CAJfuBxzmqKoxFqrX8UjHFUioHesOKUe6yZn+CdD1Fracti2MYQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf stat: add -l <N> option to redirect stderr elsewhere
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 8:35 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Thu, Sep 01, 2011 at 03:58:13PM -0600, Jim Cromie escreveu:
>> On Sat, May 21, 2011 at 2:41 PM, Arnaldo Carvalho de Melo
>> <acme@ghostprotocols.net> wrote:
>> > Em Sat, May 21, 2011 at 12:34:18PM +0200, Ingo Molnar escreveu:
>> >> * Jim Cromie <jim.cromie@gmail.com> wrote:
>> >>
>> >> > This perf stat option emulates valgrind's --log-fd option, allowing the
>> >> > user to send perf results elsewhere, and leaving stderr for use by the
>> >> > program under test.
>> >> >
>> >> >   3>results perf stat -l 3 -- <cmd>
>> >> >
>> >> > The perl distro's make test.valgrind target uses valgrinds --log-fd
>> >> > option, I've adapted it to invoke perf also, and tested this patch there.
>> >> >
>> >> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> >>
>> >> Makes sense!
>> >>
>> >> Arnaldo, if you are fine with it, do you want to pick it up - or should i? If
>> >> you pick it up:
>> >>
>> >> Acked-by: Ingo Molnar <mingo@elte.hu>
>> >
>> > Its ok with me:
>> >
>> > Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> >
>> > I will pick it this weekend, if you don't merge it till then.
>
>> Did this ever happen ?
>> Can you point me to the git-url where it did/will end up ?
>
> Fell thru the cracks, then Stephane implemented --output:
>
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-tip.git;a=commitdiff;h=4aa9015f8bfd2c8d7cc33a360275b71a9d708b37
>
> That introduces an output FILE pointer as in your patch (logfp), so I
> adjusted your patch, that ended up like below. I removed -l and made it
> --log-fd, just like valgrind and added the Documentation bits about the
> new cmdline option, ok?
>

absolutely.
theres one comment I added (just above output_fd decl)
that mentions -I, it should be updated to --log-fd

And probably --output and --log-fd should be mutually exclusive.

> I'll look at the other 3 patch series that came after, will fix up and
> post here for your consideration.

those are the output format refactoring ?

ah, your new message just arrived.
I'll take another go at them..
thanks

>
> - Arnaldo
>
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index 08394c4..b6bfd1e 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -101,6 +101,9 @@ Print the output into the designated file.
>  --append::
>  Append to the output file designated with the -o option. Ignored if -o is not specified.
>
> +--log-fd::
> +Log output to fd, instead of stderr.

stderr / outputfile ??

> +
>  EXAMPLES
>  --------
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index bec64a9..c991d66 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -196,6 +196,8 @@ static bool                 csv_output                      = false;
>  static bool                    group                           = false;
>  static const char              *output_name                    = NULL;
>  static FILE                    *output                         = NULL;
> +/* stderr by default, override with -l */

with --log-fd

> +static int                     output_fd                       = 2;
>
>  static volatile int done = 0;
>
> @@ -1080,6 +1082,8 @@ static const struct option options[] = {
>        OPT_STRING('o', "output", &output_name, "file",
>                    "output file name"),
>        OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
> +       OPT_INTEGER(0, "log-fd", &output_fd,
> +                   "log output to fd, instead of stderr"),
>        OPT_END()
>  };
>
> @@ -1177,6 +1181,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>                }
>                clock_gettime(CLOCK_REALTIME, &tm);
>                fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
> +       } else if (output_fd != 2) {
> +               output = fdopen(output_fd, "w");
> +               if (!output) {
> +                       perror("Failed opening logfd");
> +                       return -errno;
> +               }
>        }
>
>        if (csv_sep)
>
