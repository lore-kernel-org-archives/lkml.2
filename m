Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2KTRq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:46:27 -0500
Received: from 50-87-16-10.unifiedlayer.com ([50.87.16.10]:44442 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752343Ab2KTRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:46:26 -0500
Message-ID: <50ABC1C2.80505@xenotime.net>
Date: Tue, 20 Nov 2012 09:45:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Yacine Belkadi <yacine.belkadi.1@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scripts/kernel-doc: check that non-void fcts describe
 their return value
References: <1349040737-1659-1-git-send-email-yacine.belkadi.1@gmail.com> <1349040737-1659-2-git-send-email-yacine.belkadi.1@gmail.com> <50AB4D96.7050509@suse.cz>
In-Reply-To: <50AB4D96.7050509@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 01:29 AM, Michal Marek wrote:

> On 30.9.2012 23:32, Yacine Belkadi wrote:
>> If a function has a return value, but its kernel-doc comment doesn't contain a
>> "Return" section, then emit the following warning:
>>
>>    Warning(file.h:129): No description found for return value of 'fct'
>>
>> Note: This check emits a lot of warnings at the moment, because many functions
>> don't have a 'Return' doc section. So until the number of warnings goes
>> sufficiently down, the check is only performed in verbose mode.
>>
>> Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
> 
> Randy, are you fine merging this to kbuild.git?
> 
> Thanks,
> Michal

Hi Michal,
Thanks for checking with me.

Yacine, I have a few small comments on the patch.
After they are fixed, I will ack it for merging.

> 
>> ---
>>  scripts/kernel-doc |   34 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>>
>> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
>> index 8fd107a..7f82aa8 100755
>> --- a/scripts/kernel-doc
>> +++ b/scripts/kernel-doc
>> @@ -130,6 +130,8 @@ use strict;
>>  # should document the "Context:" of the function, e.g. whether the functions
>>  # can be called form interrupts. Unlike other sections you can end it with an
>>  # empty line.
>> +# A non-void function should have a "Return:" section describing the return
>> +# value.


      value(s).

>>  # Example-sections should contain the string EXAMPLE so that they are marked
>>  # appropriately in DocBook.
>>  #
>> @@ -298,6 +300,7 @@ my $section_default = "Description";	# default section
>>  my $section_intro = "Introduction";
>>  my $section = $section_default;
>>  my $section_context = "Context";
>> +my $section_return = "Return";
>>  
>>  my $undescribed = "-- undescribed --";
>>  
>> @@ -1767,6 +1770,28 @@ sub check_sections($$$$$$) {
>>  }
>>  
>>  ##
>> +# Checks the section describing the return value of a function.
>> +sub check_return_section {
>> +        my $file = shift;
>> +        my $declaration_name = shift;
>> +        my $return_type = shift;
>> +
>> +        # Ignore an empty return type (It's a macro)
>> +        # Ignore functions with a "void" return type. (But don't ignore "void *")
>> +        if (($return_type eq "") || ($return_type =~ /void\s*\w*\s*$/)) {
>> +                return;
>> +        }
>> +
>> +        if (!defined($sections{$section_return}) ||
>> +            $sections{$section_return} eq "") {
>> +                print STDERR "Warning(${file}:$.): " .
>> +                "No description found for return value of " .
>> +                "'$declaration_name'\n";
>> +                ++$warnings;


Please indent the "No description" and following lines more than the "print" line
is indented.

>> +        }
>> +}
>> +
>> +##
>>  # takes a function prototype and the name of the current file being
>>  # processed and spits out all the details stored in the global
>>  # arrays/hashes.
>> @@ -1837,6 +1862,15 @@ sub dump_function($$) {
>>  	my $prms = join " ", @parameterlist;
>>  	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
>>  
>> +        # This check emits a lot of warnings at the moment, because many
>> +        # functions don't have a 'Return' doc section. So until the number
>> +        # of warnings goes sufficiently down, the check is only performed in
>> +        # verbose mode.
>> +        # TODO: always perform the check.
>> +        if ($verbose) {
>> +                check_return_section($file, $declaration_name, $return_type);
>> +        }
>> +
>>      output_declaration($declaration_name,
>>  		       'function',
>>  		       {'function' => $declaration_name,
>>
> 
> 
> --


-- 
~Randy
